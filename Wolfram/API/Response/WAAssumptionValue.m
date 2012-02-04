//
//  WAAssumptionValue.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAssumptionValue.h"

@implementation WAAssumptionValue

@synthesize name;
@synthesize description;
@synthesize input;
@synthesize valid;

- (id)initWithName:(NSString *)aName
       description:(NSString *)aDescription
             input:(NSString *)theInput
             valid:(NSNumber *)aValid {
    if ((self = [super init])) {
        name = aName;
        description = aDescription;
        input = theInput;
        valid = aValid;
    }
    return self;
}

- (id)initWithNode:(WAXMLNode *)node {
    if ((self = [super init])) {
        name = [node valueForAttribute:@"name"];
        description = [node valueForAttribute:@"desc"];
        if ([node valueForAttribute:@"valid"]) {
            if ([[node valueForAttribute:@"valid"] isEqualToString:@"true"]) {
                valid = [NSNumber numberWithBool:YES];
            } else {
                valid = [NSNumber numberWithBool:NO];
            }
        }
        input = [node valueForAttribute:@"input"];
    }
    return self;
}

- (NSString *)assumptionValueWithDescription:(NSString *)newValue {
    NSRange lastRange = [input rangeOfString:@"_" options:NSBackwardsSearch];
    if (lastRange.location == NSNotFound) return nil;
    NSRange prefixRange = NSMakeRange(0, lastRange.location);
    NSString * prefix = [input substringWithRange:prefixRange];
    return [NSString stringWithFormat:@"%@_%@", prefix,
            [newValue stringByAddingStandardPercentEscapes]];
}

@end
