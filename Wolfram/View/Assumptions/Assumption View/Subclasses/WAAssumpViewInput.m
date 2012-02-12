//
//  WAAssumptionInput.m
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAssumpViewInput.h"

@implementation WAAssumpViewInput

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)anAssumption {
    if ((self = [super initWithEventManager:manager assumption:anAssumption])) {
        inputField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 24)];
        [inputField setStringValue:[anAssumption inputValue]];
        [inputField setTarget:self];
        [inputField setAction:@selector(inputChanged:)];
        [self addRestrainedView:inputField minWidth:100 maxWidth:CGFLOAT_MAX];
    }
    return self;
}

- (void)inputChanged:(id)sender {
    WAAssumptionValue * oldValue = [[assumption values] lastObject];
    if (!oldValue) return;
    
    WAAssumptionValue * newValue = [oldValue valueWithInputValue:[inputField stringValue]];
    WAEvent * event = [WAEvent eventWithType:WAEventTypeAssumption
                                      sender:self
                                      object:newValue
                                      forKey:kWAEventAssumptionValueUserInfoKey];
    [eventManager postEvent:event];
}

@end
