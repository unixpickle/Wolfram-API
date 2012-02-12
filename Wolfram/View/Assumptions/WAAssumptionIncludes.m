//
//  WAAssumptionIncludes.m
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAssumptionIncludes.h"

static NSSize titleSizeForButtonText(NSString * text);

@implementation WAAssumptionIncludes

@synthesize eventManager;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)anAssumption {
    if ((self = [super initWithFrame:NSMakeRect(0, 0, 1, 32)])) {
        eventManager = manager;
        assumption = anAssumption;
        
        NSString * promptString = @"Also include";
        NSFont * textFont = [NSFont systemFontOfSize:12];
        NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:textFont, NSFontAttributeName, nil];
        textSize = [promptString sizeWithAttributes:attributes];
        textSize.width += 5;
        promptLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, round((32 - textSize.height) / 2),
                                                                   textSize.width, textSize.height)];
        [promptLabel setFont:textFont];
        [promptLabel setBordered:NO];
        [promptLabel setBackgroundColor:[NSColor clearColor]];
        [promptLabel setEditable:NO];
        [promptLabel setSelectable:NO];
        [promptLabel setStringValue:promptString];
        [self addSubview:promptLabel];
        
        NSMutableArray * mButtons = [[NSMutableArray alloc] init];
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
            
            [mButtons addObject:button];
            [self addSubview:button];
        }
        buttons = [[NSArray alloc] initWithArray:mButtons];
    }
    return self;
}

- (void)resizeToWidth:(CGFloat)width {
    CGFloat totalHeight = 32;
    CGFloat xValue = promptLabel.frame.size.width + kButtonHorizontalSpace;
    for (NSUInteger i = 0; i < [buttons count]; i++) {
        NSButton * button = [buttons objectAtIndex:i];
        if (xValue + button.frame.size.width > width) {
            xValue = 0;
            totalHeight += 32 + kButtonVerticalSpace;
        }
        xValue += button.frame.size.width + kButtonHorizontalSpace;
    }
    
    NSRect frame = self.frame;
    frame.size.height = totalHeight;
    frame.size.width = width;
    self.frame = frame;
    
    promptLabel.frame = NSMakeRect(0, totalHeight - round((32 + promptLabel.frame.size.height) / 2) + 2,
                                   promptLabel.frame.size.width,
                                   promptLabel.frame.size.height);
    
    xValue = promptLabel.frame.size.width + kButtonHorizontalSpace;
    CGFloat yValue = totalHeight - 32;
    for (NSUInteger i = 0; i < [buttons count]; i++) {
        NSButton * button = [buttons objectAtIndex:i];
        
        if (xValue + button.frame.size.width > width) {
            xValue = 0;
            yValue -= 32 + kButtonVerticalSpace;
        }
        
        NSSize size = titleSizeForButtonText([button title]);
        size.width += 30;
        if (size.width + xValue > width) {
            size.width = width;
        }
        
        button.frame = NSMakeRect(xValue, yValue, size.width, button.frame.size.height);
        xValue += button.frame.size.width + kButtonHorizontalSpace;
    }
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
