//
//  WAAssumptionInput.m
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAssumptionInput.h"

@implementation WAAssumptionInput

@synthesize eventManager;

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)anAssumption {
    if ((self = [super initWithFrame:NSMakeRect(0, 0, 1, 1)])) {
        eventManager = manager;
        assumption = anAssumption;
        
        NSString * promptString = [anAssumption description];
        NSFont * font = [NSFont systemFontOfSize:12];
        NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        textSize = [promptString sizeWithAttributes:attributes];
        textSize.width += 5;
        
        promptLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, round((24 - textSize.height) / 2),
                                                                    textSize.width, textSize.height)];
        [promptLabel setFont:font];
        [promptLabel setBordered:NO];
        [promptLabel setBackgroundColor:[NSColor clearColor]];
        [promptLabel setEditable:NO];
        [promptLabel setSelectable:NO];
        [promptLabel setStringValue:promptString];
        [self addSubview:promptLabel];
        
        inputField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 24)];
        [inputField setStringValue:[anAssumption inputValue]];
        [inputField setTarget:self];
        [inputField setAction:@selector(inputChanged:)];
        [self addSubview:inputField];
    }
    return self;
}

- (void)resizeToWidth:(CGFloat)width {
    NSRect frame = self.frame;
    frame.size.width = width;

    if (textSize.width + 10 + kMinFieldWidth > width) {
        frame.size.height = 34 + textSize.height;
        [promptLabel setFrame:NSMakeRect(0, 34, width, textSize.height)];
        [inputField setFrame:NSMakeRect(0, 0, width, 24)];
    } else {
        frame.size.height = 24;
        [promptLabel setFrame:NSMakeRect(0, round((24 - textSize.height) / 2),
                                         textSize.width, textSize.height)];
        [inputField setFrame:NSMakeRect(textSize.width + 10, 0, width - (textSize.width + 10), 24)];
    }

    self.frame = frame;
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
