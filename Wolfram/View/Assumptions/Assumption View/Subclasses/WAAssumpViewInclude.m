//
//  WAAssumptionInclude.m
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAssumpViewInclude.h"

static NSSize titleSizeForButtonText(NSString * text);

@implementation WAAssumpViewInclude

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)anAssumption {
    if ((self = [super initWithEventManager:manager assumption:anAssumption])) {
        for (NSUInteger i = 0; i < [assumption.values count]; i++) {
            WAAssumptionValue * value = [assumption.values objectAtIndex:i];
            NSString * buttonText = [value description];
            
            NSSize buttonSize = titleSizeForButtonText(buttonText);
            
            NSButton * button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, buttonSize.width + 30, 32)];
            [button setStringValue:buttonText];
            [button setTitle:buttonText];
            [button setTag:i];
            [button setTarget:self];
            [button setBezelStyle:NSRoundedBezelStyle];
            [button setFont:[NSFont systemFontOfSize:13]];
            [button setAction:@selector(buttonPressed:)];
            
            [self addRestrainedView:button minWidth:(buttonSize.width + 30)
                           maxWidth:(buttonSize.width + 30)];
        }
    }
    return self;
}

- (void)buttonPressed:(id)sender {
    WAAssumptionValue * value = [[assumption values] objectAtIndex:[sender tag]];
    WAEvent * event = [WAEvent eventWithType:WAEventTypeAssumption
                                      sender:self
                                      object:value
                                      forKey:kWAEventAssumptionValueUserInfoKey];
    [eventManager postEvent:event];
}

@end

static NSSize titleSizeForButtonText(NSString * text) {
    NSFont * buttonFont = [NSFont systemFontOfSize:13];
    NSDictionary * buttonAttributes = [NSDictionary dictionaryWithObjectsAndKeys:buttonFont, NSFontAttributeName, nil];
    return [text sizeWithAttributes:buttonAttributes];
}
