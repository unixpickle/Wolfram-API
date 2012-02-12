//
//  WAAssumptionPickerView.h
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAAssumptionView.h"
#import "WAAssumption.h"

#define kPickerMinWidth 100
#define kPickerSpacing 5

@interface WAAssumptionPickerView : NSView <WAAssumptionView> {
    WAAssumption * assumption;
    NSPopUpButton * popupButton;
    NSTextField * popupLabel;
    NSSize textSize;
    __weak WAEventManager * eventManager;
}

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)anAssumption;
- (id)initWithEventManager:(WAEventManager *)manager
                assumption:(WAAssumption *)anAssumption
                    prompt:(NSString *)promptString;

- (void)popupButtonChanged:(id)sender;

@end
