//
//  WAAssumptionPickerView.m
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAssumpViewPicker.h"

@implementation WAAssumpViewPicker

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)anAssumption {
    if ((self = [super initWithEventManager:manager assumption:anAssumption])) {
        popupButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 100, 24)];
        for (WAAssumptionValue * value in [assumption values]) {
            [popupButton addItemWithTitle:[value description]];
        }
        if ([assumption current]) {
            [popupButton selectItemAtIndex:[assumption.current intValue]];
        } else {
            [popupButton selectItemAtIndex:0];
        }
        [popupButton setTarget:self];
        [popupButton setAction:@selector(popupButtonChanged:)];
        [self addRestrainedView:popupButton minWidth:100 maxWidth:CGFLOAT_MAX];
    }
    return self;
}

- (void)popupButtonChanged:(id)sender {
    NSUInteger index = [popupButton indexOfSelectedItem];
    WAAssumptionValue * value = [[assumption values] objectAtIndex:index];
    WAEvent * event = [WAEvent eventWithType:WAEventTypeAssumption
                                      sender:self
                                      object:value
                                      forKey:kWAEventAssumptionValueUserInfoKey];
    [eventManager postEvent:event];
}

@end
