//
//  WAView.m
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAView.h"

@interface WAView (Private)

- (void)windowBecameKey:(NSNotification *)notification;
- (void)windowResignedKey:(NSNotification *)notification;

- (NSSize)contentViewportSize;
- (void)layoutContentView;

@end

@implementation WAView

@synthesize delegate;

#pragma mark - View Mechanics -

- (id)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        itemViews = [[NSMutableArray alloc] init];
        eventManager = [[WAEventManager alloc] initWithTarget:self];
        
        scrollView = [[NSScrollView alloc] initWithFrame:self.bounds];
        clipView = [[NSClipView alloc] initWithFrame:self.bounds];
        [scrollView setHasVerticalScroller:YES];
        [scrollView setBorderType:NSNoBorder];
        [scrollView setDocumentView:clipView];
        [clipView setCopiesOnScroll:NO];
        
        NSSize size = [self contentViewportSize];
        contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, size.width, size.height)];
        [clipView setDocumentView:contentView];
        
        [self addSubview:scrollView];
        
        // create search item
        NSRect searchFrame = NSMakeRect(10, 10, size.width - 20, 0);
        WAViewSearchItem * search = [[WAViewSearchItem alloc] initWithFrame:searchFrame title:@"Search"];
        [self addItem:search];
    }
    return self;
}

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    [scrollView setFrame:frame];
    
    [self layoutContentView];
}

- (void)removeFromSuperview {
    [self detachWindowNotifications];
}

- (void)dealloc {
    [self detachWindowNotifications];
}

#pragma mark - Window Notifications -

- (void)hookupWindowNotifications {
    if (configuredNotifications) return;
    NSWindow * window = self.window;
    if (!window) return;
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(windowBecameKey:)
                                                 name:NSWindowDidBecomeKeyNotification
                                               object:window];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(windowResignedKey:)
                                                 name:NSWindowDidResignKeyNotification
                                               object:window];
    configuredNotifications = YES;
    if (![window isKeyWindow]) {
        [self windowResignedKey:nil];
    } else {
        [self windowBecameKey:nil];
    }
}

- (void)detachWindowNotifications {
    if (!configuredNotifications) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    configuredNotifications = NO;
}

#pragma mark (Private) Callbacks

- (void)windowBecameKey:(NSNotification *)notification {
    for (WAViewItem * item in itemViews) {
        [item setFocused:YES];
    }
}

- (void)windowResignedKey:(NSNotification *)notification {
    for (WAViewItem * item in itemViews) {
        [item setFocused:NO];
    }
}

#pragma mark - Events -

- (void)eventManager:(WAEventManager *)manager receivedEvent:(WAEvent *)event {
    if (event.eventType == WAEventTypeExpandCollapse || event.eventType == WAEventTypeHeightChange) {
        NSRect topDownFrame = [scrollView documentVisibleRect];
        [self layoutContentView];
        float delta = [[[event userInfo] objectForKey:kWAEventDeltaHeightUserInfoKey] floatValue];

        topDownFrame.origin.y += delta;
        if (topDownFrame.origin.y < 0) {
            topDownFrame.origin.y = 0;
        } else if (topDownFrame.origin.y + topDownFrame.size.height > clipView.frame.size.height) {
            topDownFrame.origin.y = clipView.frame.size.height - topDownFrame.size.height;
        }
        [[scrollView contentView] scrollRectToVisible:topDownFrame];
        [scrollView reflectScrolledClipView:[scrollView contentView]];
    } else if (event.eventType == WAEventTypeSearch) {
        NSString * query = [event.userInfo objectForKey:kWAEventQueryUserInfoKey];
        if ([delegate respondsToSelector:@selector(waView:searchQuery:)]) {
            [delegate waView:self searchQuery:query];
        }
    }
}

#pragma mark - Items -

#pragma mark Management

- (void)addItem:(WAViewItem *)item {
    [item setEventManager:eventManager];
    [itemViews addObject:item];
    [self layoutContentView];
}

- (void)removeItems {
    while ([itemViews count] > 1) {
        WAViewItem * item = [itemViews lastObject];
        [item removeFromSuperview];
        [itemViews removeLastObject];
    }
    [self layoutContentView];
}

- (WAViewSearchItem *)searchItem {
    return [itemViews objectAtIndex:0];
}

- (WAViewPodItem *)addPodItem:(WAPod *)aPod {
    WAViewPodItem * newItem = [[WAViewPodItem alloc] initWithFrame:NSMakeRect(0, 0, [self contentViewportSize].width - 20, 0)
                                                               pod:aPod];
    // TODO: collapse it if it's past result #5 or something
    [newItem setEventManager:eventManager];
    for (NSUInteger i = 0; i < [itemViews count]; i++) {
        WAViewItem * item = [itemViews objectAtIndex:i];
        if ([item isKindOfClass:[WAViewPodItem class]]) {
            WAViewPodItem * podItem = (WAViewPodItem *)item;
            if ([[[podItem pod] identifier] isEqualToString:[aPod identifier]]) {
                // TODO: copy expanded state
                [podItem removeFromSuperview];
                [itemViews replaceObjectAtIndex:i withObject:newItem];
                [self layoutContentView];
                return newItem;
            }
        }
    }
    
    NSRect topDownFrame = [scrollView documentVisibleRect];
    CGFloat oldHeight = contentView.frame.size.height;

    [self addItem:newItem];    
        
    CGFloat newHeight = contentView.frame.size.height;
    topDownFrame.origin.y += newHeight - oldHeight;
    
    [[scrollView contentView] scrollRectToVisible:topDownFrame];
    [scrollView reflectScrolledClipView:[scrollView contentView]];
    
    return newItem;
}

#pragma mark (Private) Content View

- (NSSize)contentViewportSize {
    NSSize size = [NSScrollView contentSizeForFrameSize:scrollView.frame.size
                                  hasHorizontalScroller:scrollView.hasHorizontalScroller
                                    hasVerticalScroller:scrollView.hasVerticalScroller
                                             borderType:scrollView.borderType];
    return size;
}

- (void)layoutContentView {
    CGFloat height = 10;
    CGSize size = [self contentViewportSize];
    NSRect visibleRect = [scrollView documentVisibleRect];
    for (NSInteger i = [itemViews count] - 1; i >= 0; i--) {
        WAViewItem * item = [itemViews objectAtIndex:i];
        NSRect frame = [item frame];
        CGFloat oldHeight = frame.size.height;
        frame.size.width = size.width - 20;
        frame.origin.x = 10;
        frame.origin.y = height;
        [item setFrame:frame];
        height += item.frame.size.height + 10;
        CGFloat newHeight = item.frame.size.height;
        if (oldHeight != newHeight) {
            visibleRect.origin.y += (newHeight - oldHeight);
        }
        if (![item superview]) {
            [contentView addSubview:item];
        }
    }

    if (height < size.height) {
        CGFloat offset = size.height - height;
        height = size.height;
        for (WAViewItem * item in itemViews) {
            NSRect frame = [item frame];
            frame.origin.y += offset;
            [item setFrame:frame];
        }
    }
    
    [contentView setFrame:NSMakeRect(0, 0, size.width, height)];
    [clipView setFrame:NSMakeRect(0, 0, size.width, height)];
    
    if (visibleRect.origin.y < 0) {
        visibleRect.origin.y = 0;
    } else if (visibleRect.origin.y + visibleRect.size.height > clipView.frame.size.height) {
        visibleRect.origin.y = clipView.frame.size.height - visibleRect.size.height;
    }
    [[scrollView contentView] scrollRectToVisible:visibleRect];
}

@end
