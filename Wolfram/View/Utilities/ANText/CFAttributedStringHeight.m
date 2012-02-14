//
//  CFAttributedStringHeight.m
//  TypingTest
//
//  Created by Alex Nichol on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CFAttributedStringHeight.h"

static CGContextRef DrawHeightContext (CGFloat width, CGFloat height);

CGFloat CFAttributedStringDrawHeight (CFAttributedStringRef string, CGFloat width, CGContextRef context) {
    NSRect boundsRect = NSMakeRect(0, 0, width, 10000);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, boundsRect);
    
    BOOL shouldFreeContext = NO;
    if (!context) {
        context = DrawHeightContext(width, 10);
        shouldFreeContext = YES;
    }
    
    ANTextFrame * frame = [[ANTextFrame alloc] initWithAttributedString:string
                                                                context:context
                                                                   path:path];
    
    if (shouldFreeContext) CGContextRelease(context);
    CGPathRelease(path);
    
    return ceil([frame boundingRect].size.height);
}

static CGContextRef DrawHeightContext (CGFloat width, CGFloat height) {
    CGContextRef context = NULL;
    size_t pixWide = (size_t)width, pixHigh = (size_t)height;
    CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(NULL, pixWide, pixHigh,
                                    8, (4 * width), rgbSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(rgbSpace);
    return context;
}
