//
//  ANTextFrame.m
//  TypingTest
//
//  Created by Alex Nichol on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANTextFrame.h"

@implementation ANTextFrame

- (id)initWithCTFrame:(CTFrameRef)theFrame context:(CGContextRef)theContext {
    if ((self = [super init])) {
        frame = CFRetain(theFrame);
        context = CGContextRetain(theContext);
    }
    return self;
}

- (id)initWithAttributedString:(CFAttributedStringRef)aString context:(CGContextRef)theContext path:(CGPathRef)path {
    if ((self = [super init])) {
        CTFramesetterRef setter = CTFramesetterCreateWithAttributedString(aString);
        frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, 0), path, NULL);
        context = CGContextRetain(theContext);
        CFRelease(setter);
    }
    return self;
}

- (CTFrameRef)CTFrame {
    return frame;
}

- (CGRect)boundingRect {
    CGFloat maxY = CGFLOAT_MIN, minY = CGFLOAT_MAX;
    CGFloat maxX = CGFLOAT_MIN, minX = CGFLOAT_MAX;
    NSArray * lines = [self lines];
    for (ANTextLine * line in lines) {
        CGRect bounds = [line boundingRect];
        if (CGRectGetMaxY(bounds) > maxY)
            maxY = CGRectGetMaxY(bounds);
        if (CGRectGetMinY(bounds) < minY)
            minY = CGRectGetMinY(bounds);
        if (CGRectGetMaxX(bounds) > maxX)
            maxX = CGRectGetMaxX(bounds);
        if (CGRectGetMinY(bounds) < minX)
            minX = CGRectGetMinX(bounds);
    }
    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}

- (NSArray *)lines {
    NSMutableArray * lineArray = [[NSMutableArray alloc] init];
    
    CFArrayRef array = CTFrameGetLines(frame);
    CGPoint * origins = (CGPoint *)malloc(sizeof(CGPoint) * CFArrayGetCount(array));
    CTFrameGetLineOrigins(frame, CFRangeMake(0, CFArrayGetCount(array)), origins);
    
    CGPathRef path = CTFrameGetPath(frame);
    CGRect pathBox = CGPathGetBoundingBox(path);
    
    for (NSUInteger i = 0; i < CFArrayGetCount(array); i++) {
        CGPoint origin = origins[i];
        origin.x += pathBox.origin.x;
        origin.y += pathBox.origin.y;
        
        CTLineRef aLine = (CTLineRef)CFArrayGetValueAtIndex(array, i);
        ANTextLine * line = [[ANTextLine alloc] initWithCTLine:aLine origin:origin context:context];
        [lineArray addObject:line];
    }
    
    free(origins);
    
    return [NSArray arrayWithArray:lineArray];
}

- (void)draw {
    CTFrameDraw(frame, context);
}

- (void)dealloc {
    CFRelease(frame);
    CGContextRelease(context);
}

@end
