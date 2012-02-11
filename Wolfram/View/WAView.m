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
        scrollStates = [[NSMutableArray alloc] init];
        
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
        WAViewSearchCell * search = [[WAViewSearchCell alloc] initWithEventManager:eventManager
                                                                             title:@"Search"];
        [self addCell:search];
        [self layoutContentView];
    }
    return self;
}

- (void)setFrame:(NSRect)frame {
    [self saveScrollRect];
    [super setFrame:frame];
    [scrollView setFrame:frame];
    [self restoreScrollRect];
    
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
    if (event.eventType == WAEventTypeExpandCollapse) {
        [self layoutContentView];
    } else if (event.eventType == WAEventTypeSearch) {
        NSString * query = [event.userInfo objectForKey:kWAEventQueryUserInfoKey];
        if ([delegate respondsToSelector:@selector(waView:searchQuery:)]) {
            [delegate waView:self searchQuery:query];
        }
    }
}

#pragma mark - Scrolling -

- (void)saveScrollRect {
    NSRect rect = [scrollView documentVisibleRect];
    CGFloat height = contentView.frame.size.height;
    WAScrollState * state = [[WAScrollState alloc] initWithVisibleRect:rect contentHeight:height];
    [scrollStates addObject:state];
}

- (void)restoreScrollRect {
    if ([scrollStates count] == 0) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Scroll restore stack empty, cannot pop"
                                     userInfo:nil];
    }
    
    WAScrollState * state = [scrollStates lastObject];
    [scrollStates removeLastObject];
    NSRect oldRect = state.visibleRect;
    CGFloat newHeight = contentView.frame.size.height;
    CGFloat newVisibleHeight = [self contentViewportSize].height;
    oldRect.origin.y += newHeight - state.contentHeight;
    
    // anchor the top in the case of size changes
    oldRect.origin.y += (oldRect.size.height - newVisibleHeight);
    oldRect.size.height = newVisibleHeight;
    
    if (oldRect.origin.y < 0) {
        oldRect.origin.y = 0;
    } else if (oldRect.origin.y + oldRect.size.height > clipView.frame.size.height) {
        oldRect.origin.y = clipView.frame.size.height - oldRect.size.height;
    }
    
    [[scrollView contentView] scrollRectToVisible:oldRect];
    [scrollView reflectScrolledClipView:[scrollView contentView]];
}

#pragma mark - Items -

#pragma mark Management

- (void)addItem:(WAViewItem *)item {
    [item setEventManager:eventManager];
    [itemViews addObject:item];
    [self saveScrollRect];
    [self layoutContentView];
    [self restoreScrollRect];
}

- (WAViewItem *)addCell:(WAViewItemCell *)cell {
    WAViewItem * item = [[WAViewItem alloc] initWithItemCell:cell];
    [self addItem:item];
    return item;
}

- (void)removeItems {
    while ([itemViews count] > 1) {
        WAViewItem * item = [itemViews lastObject];
        [item removeFromSuperview];
        [itemViews removeLastObject];
    }
    [self layoutContentView];
}

- (WAViewSearchCell *)searchCell {
    return (WAViewSearchCell *)[[itemViews objectAtIndex:0] itemCell];
}

- (WAViewPodCell *)addPodCell:(WAPod *)aPod {
    WAViewPodCell * newCell = [[WAViewPodCell alloc] initWithEventManager:eventManager pod:aPod];
    WAViewItem * newItem = [[WAViewItem alloc] initWithItemCell:newCell];
    if ([[aPod subPods] count] == 0) {
        [newCell setLoading:YES];
    }
    for (NSUInteger i = 0; i < [itemViews count]; i++) {
        WAViewItem * item = [itemViews objectAtIndex:i];
        if ([item.itemCell isKindOfClass:[WAViewPodCell class]]) {
            WAViewPodCell * podItem = (WAViewPodCell *)item.itemCell;
            if ([[[podItem pod] identifier] isEqualToString:[aPod identifier]]) {
                BOOL isExpanded = [item isExpanded];
                [self saveScrollRect];
                
                [item removeFromSuperview];
                [itemViews replaceObjectAtIndex:i withObject:newItem];
                if (!isExpanded) [newItem setExpanded:NO];
                [self layoutContentView];
                
                [self restoreScrollRect];
                return newCell;
            }
        }
    }

    [self addItem:newItem];
    return newCell;
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
    [self saveScrollRect];
    
    for (NSInteger i = [itemViews count] - 1; i >= 0; i--) {
        WAViewItem * item = [itemViews objectAtIndex:i];
        NSRect frame = [item frame];
        frame.size.width = size.width - 20;
        frame.origin.x = 10;
        frame.origin.y = height;
        [item setFrame:frame];
        [item fitBoundsToWidth];
        height += item.frame.size.height + 10;
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
    
    [self restoreScrollRect];
    
    // redraw all of the pod items
    for (NSInteger i = [itemViews count] - 1; i >= 0; i--) {
        WAViewItem * item = [itemViews objectAtIndex:i];
        [item setNeedsDisplay:YES];
    }
}

@end
