//
//  NSError+Message.h
//  Wolfram
//
//  Created by Alex Nichol on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Message)

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSUInteger)code message:(NSString *)msg;

@end
