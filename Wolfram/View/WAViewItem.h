//
//  WAViewItem.h
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAEventManager.h"

#define kTitleHeight 21

@interface WAViewItem : NSView {
    NSString * title;
    NSButton * expandButton;
    NSProgressIndicator * loadIndicator;
    BOOL loading;
    BOOL focused;
    BOOL highlighted;
    __weak WAEventManager * eventManager;
}

@property (nonatomic, retain) NSString * title;
@property (readwrite, getter = isLoading) BOOL loading;
@property (readwrite, getter = isFocused) BOOL focused;
@property (readwrite, getter = isHighlighted) BOOL highlighted;
@property (readwrite, weak) WAEventManager * eventManager;

- (id)initWithFrame:(NSRect)frame title:(NSString *)aTitle;
+ (CGFloat)contentHeight;
+ (CGFloat)initialHeight;

- (void)expandCollapsePress:(id)sender;
- (void)expand;
- (void)collapse;

@end
