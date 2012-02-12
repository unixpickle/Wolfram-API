//
//  WAAssumptionInput.h
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAAssumptionView.h"
#import "WAAssumption.h"

#define kMinFieldWidth 100

@interface WAAssumptionInput : NSView <WAAssumptionView> {
    WAAssumption * assumption;
    NSTextField * promptLabel;
    NSTextField * inputField;
    NSSize textSize;
}

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)assumption;
- (void)inputChanged:(id)sender;

@end
