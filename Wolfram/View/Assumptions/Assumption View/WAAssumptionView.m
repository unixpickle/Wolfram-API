//
//  WAAssumptionView.m
//  Wolfram
//
//  Created by Alex Nichol on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAssumptionView.h"

@implementation WAAssumptionView

@synthesize assumption;
@synthesize eventManager;

- (id)initWithEventManager:(WAEventManager *)manager assumption:(WAAssumption *)anAssumption {
    self = [self initWithEventManager:manager
                           assumption:anAssumption
                               prompt:[anAssumption promptLabel]];
    return self;
}

- (id)initWithEventManager:(WAEventManager *)manager
                assumption:(WAAssumption *)anAssumption
                    prompt:(NSString *)prompt {
    if ((self = [super initWithFrame:NSMakeRect(0, 0, 1, 1)])) {
        NSSize textSize;
        NSTextField * promptLabel;
        
        assumption = anAssumption;
        eventManager = manager;
        restrainedViews = [[NSMutableArray alloc] init];
        
        NSFont * font = [NSFont systemFontOfSize:12];
        NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                     font, NSFontAttributeName, nil];
        textSize = [prompt sizeWithAttributes:attributes];
        textSize.width += 5;
        
        promptLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, round((24 - textSize.height) / 2),
                                                                    textSize.width, textSize.height)];
        [promptLabel setFont:font];
        [promptLabel setBordered:NO];
        [promptLabel setBackgroundColor:[NSColor clearColor]];
        [promptLabel setEditable:NO];
        [promptLabel setSelectable:NO];
        [promptLabel setStringValue:prompt];
        [self addRestrainedView:promptLabel minWidth:textSize.width maxWidth:textSize.width];
    }
    return self;
}

- (void)addRestrainedView:(NSView *)view minWidth:(CGFloat)min maxWidth:(CGFloat)max {
    WAViewRestraints * layoutInfo = [[WAViewRestraints alloc] initWithView:view
                                                                       min:min
                                                                       max:max];
    [restrainedViews addObject:layoutInfo];
}

- (void)resizeToWidth:(CGFloat)width {
    NSArray * lines = [WAViewRestraints linesForRestraints:restrainedViews
                                                 withWidth:width];
    CGFloat yValue = 0;
    
    for (NSInteger i = [lines count] - 1; i >= 0; i--) {
        NSArray * line = [lines objectAtIndex:i];
        CGFloat lineHeight = 0;
        for (WAViewRestraints * info in line) {
            lineHeight = MAX(info.usingRect.size.height, lineHeight);
        }
        for (WAViewRestraints * info in line) {
            NSRect frame = [info usingRect];
            frame.origin.y = round((lineHeight - frame.size.height) / 2.0) + yValue;
            info.view.frame = frame;
            if (![info.view superview]) {
                [self addSubview:info.view];
            }
        }
        yValue += lineHeight;
    }
    
    NSRect frame = self.frame;
    frame.size.height = yValue;
    frame.size.width = width;
    self.frame = frame;
}

@end
