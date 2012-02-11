//
//  WAAssumptionPickerView.m
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAssumptionPickerView.h"

@implementation WAAssumptionPickerView

@synthesize eventManager;

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)anAssumption {
    self = [self initWithEventManager:manager assumption:anAssumption prompt:[anAssumption promptLabel]];
    return self;
}

- (id)initWithEventManager:(WAEventManager *)manager
                assumption:(WAAssumption *)anAssumption
                    prompt:(NSString *)promptString {
    if ((self = [super initWithFrame:NSMakeRect(0, 0, 1, 1)])) {
        NSRect frame = NSZeroRect;
        eventManager = manager;
        assumption = anAssumption;
        NSFont * textFont = [NSFont systemFontOfSize:12];
        NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:textFont, NSFontAttributeName, nil];
        textSize = [promptString sizeWithAttributes:attributes];
        textSize.width += 5;
        popupLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, round((24 - textSize.height) / 2),
                                                                   textSize.width, textSize.height)];
        [popupLabel setFont:textFont];
        [popupLabel setBordered:NO];
        [popupLabel setBackgroundColor:[NSColor clearColor]];
        [popupLabel setEditable:NO];
        [popupLabel setSelectable:NO];
        [popupLabel setStringValue:promptString];
        
        popupButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(textSize.width + kPickerSpacing, 0, kPickerMinWidth, 24)];
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
        
        frame.size.width = popupButton.frame.size.width + popupButton.frame.origin.x;
        frame.size.height = 24;
        self.frame = frame;
        [self addSubview:popupButton];
        [self addSubview:popupLabel];
    }
    return self;
}

- (void)resizeToWidth:(CGFloat)width {
    NSRect frame = self.frame;
    if (kPickerMinWidth + kPickerSpacing + textSize.width <= width) {
        frame.size.width = width;
        frame.size.height = 24;
        popupLabel.frame = NSMakeRect(0, round((24 - textSize.height) / 2),
                                      textSize.width, textSize.height);
        popupButton.frame = NSMakeRect(textSize.width + kPickerSpacing, 0, width - (textSize.width + kPickerSpacing), 24);
    } else {
        frame.size.width = width;
        frame.size.height = 34 + textSize.height;
        popupLabel.frame = NSMakeRect(0, 34, width, textSize.height);
        popupButton.frame = NSMakeRect(0, 0, width, 24);
    }
    self.frame = frame;
}

- (void)popupButtonChanged:(id)sender {
    NSUInteger index = [popupButton indexOfSelectedItem];
    WAAssumptionValue * value = [[assumption values] objectAtIndex:index];
    WAEvent * event = [WAEvent eventWithType:WAEventTypeAssumption sender:self
                                      object:value forKey:kWAEventAssumptionValueUserInfoKey];
    [eventManager postEvent:event];
}

@end
