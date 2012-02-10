//
//  WAViewItem.h
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAViewEvent.h"

#define kTitleHeight 21

@class WAViewItem;

@protocol WAViewItemDelegate

- (void)viewItem:(WAViewItem *)item event:(WAViewEvent *)event;

@end

@interface WAViewItem : NSView {
    NSString * title;
    BOOL loading;
    NSButton * expandButton;
    BOOL focused;
    BOOL highlighted;
    __weak id<WAViewItemDelegate> delegate;
}

@property (nonatomic, retain) NSString * title;
@property (readwrite, getter = isLoading) BOOL loading;
@property (readwrite, getter = isFocused) BOOL focused;
@property (readwrite, getter = isHighlighted) BOOL highlighted;
@property (nonatomic, weak) id<WAViewItemDelegate> delegate;

- (id)initWithFrame:(NSRect)frame title:(NSString *)aTitle;
+ (CGFloat)contentHeight;
+ (CGFloat)initialHeight;

- (void)expandCollapsePress:(id)sender;
- (void)expand;
- (void)collapse;

@end
