//
//  WAViewItem.h
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAEventManager.h"
#import "WAViewItemCell.h"

#define kTitleHeight 21

@interface WAViewItem : NSView {
    NSButton * expandButton;
    NSProgressIndicator * loadIndicator;
    BOOL focused;
    BOOL highlighted;
    __weak WAEventManager * eventManager;
    WAViewItemCell * itemCell;
}

@property (readwrite, getter = isFocused) BOOL focused;
@property (readwrite, getter = isHighlighted) BOOL highlighted;
@property (readwrite, weak) WAEventManager * eventManager;
@property (readonly) WAViewItemCell * itemCell;

- (id)initWithItemCell:(WAViewItemCell *)theCell;
- (CGFloat)totalViewHeight;
- (void)fitBoundsToWidth;

- (void)expandCollapsePress:(id)sender;
- (void)setExpanded:(BOOL)expanded;
- (BOOL)isExpanded;
- (void)layoutExpanded;
- (void)layoutCollapsed;

@end
