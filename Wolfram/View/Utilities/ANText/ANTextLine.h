//
//  ANTextLine.h
//  TypingTest
//
//  Created by Alex Nichol on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANTextLine : NSObject {
    CTLineRef line;
    CGPoint origin;
    CGContextRef context;
}

- (id)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)theOrigin context:(CGContextRef)theContext;

- (CTLineRef)CTLine;
- (CGPoint)origin;
- (CGRect)boundingRect;

- (CGFloat)offsetOfCharacter:(NSUInteger)charIndex;
- (BOOL)containsCharacterIndex:(NSUInteger)charIndex;

@end
