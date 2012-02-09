//
//  WAView.m
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAView.h"

@interface WAView (Private)

- (NSSize)contentViewportSize;
- (void)layoutContentView;

@end

@implementation WAView

@synthesize delegate;

- (id)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        itemViews = [[NSMutableArray alloc] init];
        
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
        WAViewSearchItem * search = [[WAViewSearchItem alloc] initWithFrame:searchFrame
                                                                      title:@"Search"];
        [search setDelegate:self];
        [itemViews addObject:search];
        [self layoutContentView];
    }
    return self;
}

#pragma mark - Items -

#pragma mark Delegate

- (void)viewItem:(WAViewItem *)item event:(WAViewEvent *)event {
    if ([event eventType] == WAViewEventTypeResize) {
        [self layoutContentView];
    } else {
        [delegate waView:self item:item event:event];
    }
}
                       
#pragma mark - Private -

#pragma mark Content View
                       
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
    for (NSInteger i = [itemViews count] - 1; i >= 0; i--) {
        WAViewItem * item = [itemViews objectAtIndex:i];
        NSRect frame = [item frame];
        frame.size.width = size.width - 20;
        frame.origin.x = 10;
        frame.origin.y = height;
        height += frame.size.height + 10;
        [item setFrame:frame];
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
}

@end
