//
//  WAViewItemCell.h
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAEventManager.h"

@class WAViewItem;

@interface WAViewItemCell : NSView {
    __weak WAEventManager * eventManager;
    BOOL loading;
    NSString * title;
}

@property (nonatomic, weak) WAEventManager * eventManager;
@property (readwrite, getter = isLoading) BOOL loading;
@property (readonly) NSString * title;

- (id)initWithEventManager:(WAEventManager *)manager title:(NSString *)aTitle;
- (void)resizeToWidth:(CGFloat)width;

@end
