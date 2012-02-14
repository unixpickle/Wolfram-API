//
//  ANTextFrame.h
//  TypingTest
//
//  Created by Alex Nichol on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANTextLine.h"

@interface ANTextFrame : NSObject {
    CTFrameRef frame;
    CGContextRef context;
}

- (id)initWithCTFrame:(CTFrameRef)theFrame context:(CGContextRef)theContext;
- (id)initWithAttributedString:(CFAttributedStringRef)aString context:(CGContextRef)theContext path:(CGPathRef)path;

- (CTFrameRef)CTFrame;
- (CGRect)boundingRect;
- (NSArray *)lines;

- (void)draw;

@end
