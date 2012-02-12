//
//  WAAssumptionIncludes.h
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAAssumptionView.h"
#import "WAAssumption.h"

#define kButtonHorizontalSpace 0
#define kButtonVerticalSpace 5

@interface WAAssumptionIncludes : NSView <WAAssumptionView> {
    WAAssumption * assumption;
    NSTextField * promptLabel;
    NSSize textSize;
    NSArray * buttons;
}

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)assumption;
- (void)buttonPressed:(id)sender;

@end
