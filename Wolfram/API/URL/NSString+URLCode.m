//
//  NSString+URLCode.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+URLCode.h"

@implementation NSString (URLCode)

- (NSString *)stringByAddingStandardPercentEscapes {
    NSMutableString * encoded = [[NSMutableString alloc] init];
    NSCharacterSet * acceptable = [NSCharacterSet characterSetWithCharactersInString:@" _-*:"];
    
    for (NSUInteger i = 0; i < [self length]; i++) {
        unichar character = [encoded characterAtIndex:i];
        if (!isalnum(character) && ![acceptable characterIsMember:character]) {
            [encoded appendFormat:@"%%%02X", (unsigned char)character];
        } else if (character == ' ') {
            [encoded appendString:@"+"];
        } else {
            [encoded appendFormat:@"%C", character];
        }
    }
    
    return [NSString stringWithString:encoded];
}

- (NSString *)stringByEvaluatingPercentEscapes {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
