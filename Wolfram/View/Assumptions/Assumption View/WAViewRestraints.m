//
//  WAViewRestraints.m
//  Wolfram
//
//  Created by Alex Nichol on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewRestraints.h"

@implementation WAViewRestraints

@synthesize view;
@synthesize minWidth;
@synthesize maxWidth;
@synthesize usingRect;

- (id)initWithView:(NSView *)aView min:(CGFloat)min max:(CGFloat)max {
    if ((self = [super init])) {
        view = aView;
        minWidth = min;
        maxWidth = max;
    }
    return self;
}

- (BOOL)canFitOnLine:(CGFloat)lineWidth {
    return lineWidth >= minWidth;
}

- (CGFloat)widthForLine:(CGFloat)lineWidth {
    if (minWidth > lineWidth) return lineWidth;
    if (maxWidth > minWidth) return MIN(maxWidth, lineWidth);
    return minWidth;
}

+ (NSArray *)linesForRestraints:(NSArray *)layouts withWidth:(CGFloat)width {
    NSMutableArray * lines = [NSMutableArray arrayWithCapacity:[layouts count]];
    NSMutableArray * currentLine = [NSMutableArray arrayWithCapacity:[layouts count]];
    CGFloat xValue = 0;
    for (NSInteger i = 0; i < [layouts count]; i++) {
        WAViewRestraints * layoutInfo = [layouts objectAtIndex:i];
        NSView * view = [layoutInfo view];
        CGFloat lineWidth = (width - xValue);
        if ([currentLine count] == 0 || [layoutInfo canFitOnLine:lineWidth]) {
            CGFloat usingWidth = [layoutInfo widthForLine:lineWidth];
            NSRect usingRect = layoutInfo.usingRect;
            usingRect.size.width = usingWidth;
            usingRect.size.height = view.frame.size.height;
            usingRect.origin.x = xValue;
            layoutInfo.usingRect = usingRect;
            xValue += usingWidth + 10;
            [currentLine addObject:layoutInfo];
        } else {
            // push existing items of this line to the line array,
            // then push this view to the next line.
            [lines addObject:[NSArray arrayWithArray:currentLine]];
            currentLine = [NSMutableArray arrayWithCapacity:([layouts count] - i)];
            xValue = 0;
            i--;
            continue;
        }
    }
    if ([currentLine count] > 0) {
        [lines addObject:[NSArray arrayWithArray:currentLine]];
    }
    return [NSArray arrayWithArray:lines];
}

@end
