//
//  NSError+Message.m
//  Wolfram
//
//  Created by Alex Nichol on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSError+Message.h"

@implementation NSError (Message)

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSUInteger)code message:(NSString *)msg {
    NSDictionary * info = [NSDictionary dictionaryWithObject:msg
                                                      forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:domain code:code userInfo:info];
}

@end
