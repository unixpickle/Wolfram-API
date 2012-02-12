//
//  WAViewRestraints.h
//  Wolfram
//
//  Created by Alex Nichol on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WAViewRestraints : NSObject {
    NSView * view;
    CGFloat minWidth;
    CGFloat maxWidth;
    NSRect usingRect;
}

@property (readonly) NSView * view;
@property (readonly) CGFloat minWidth;
@property (readonly) CGFloat maxWidth;
@property (readwrite) NSRect usingRect;

- (id)initWithView:(NSView *)aView min:(CGFloat)min max:(CGFloat)max;
- (BOOL)canFitOnLine:(CGFloat)lineWidth;
- (CGFloat)widthForLine:(CGFloat)lineWidth;

+ (NSArray *)linesForRestraints:(NSArray *)layouts withWidth:(CGFloat)width;

@end
