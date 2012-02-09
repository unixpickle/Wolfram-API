//
//  WAView.h
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "WAViewItem.h"
#import "WAViewSearchItem.h"

@class WAView;

@protocol WAViewDelegate

- (void)waView:(WAView *)view item:(WAViewItem *)item event:(WAViewEvent *)event;

@end

@interface WAView : NSView <WAViewItemDelegate> {
    NSScrollView * scrollView;
    NSClipView * clipView;
    NSView * contentView;
    
    NSMutableArray * itemViews;
    __weak id<WAViewDelegate> delegate;
}

@property (nonatomic, weak) id<WAViewDelegate> delegate;

- (id)initWithFrame:(NSRect)frameRect;

@end
