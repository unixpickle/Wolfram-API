//
//  WAAssumptionView.h
//  Wolfram
//
//  Created by Alex Nichol on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAEventManager.h"
#import "WAAssumption.h"
#import "WAViewRestraints.h"

#define kHorizontalSpacing 10

@interface WAAssumptionView : NSView {
    WAAssumption * assumption;
    __weak WAEventManager * eventManager;
    NSMutableArray * restrainedViews;
}

@property (readonly) WAAssumption * assumption;
@property (readonly) WAEventManager * eventManager;

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)anAssumption;
- (id)initWithEventManager:(WAEventManager *)manager
                assumption:(WAAssumption *)anAssumption
                    prompt:(NSString *)prompt;

- (NSTextField *)promptTextField;
- (void)addRestrainedView:(NSView *)view minWidth:(CGFloat)min maxWidth:(CGFloat)max;
- (void)resizeToWidth:(CGFloat)width;

@end
