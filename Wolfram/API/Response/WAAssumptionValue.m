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
@synthesize assumption;

- (id)initWithName:(NSString *)aName
       description:(NSString *)aDescription
             input:(NSString *)theInput
             valid:(NSNumber *)aValid
        assumption:(WAAssumption *)parent {
    if ((self = [super init])) {
        name = aName;
        description = aDescription;
        input = theInput;
        valid = aValid;
        assumption = parent;
    }
    return self;
}

- (id)initWithNode:(WAXMLNode *)node assumption:(WAAssumption *)parent {
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
        input = [[node valueForAttribute:@"input"] stringByEvaluatingPercentEscapes];
        assumption = parent;
    }
    return self;
}

- (WAAssumptionValue *)valueWithInputValue:(NSString *)newValue {
    NSRange lastRange = [input rangeOfString:@"_" options:NSBackwardsSearch];
    if (lastRange.location == NSNotFound) return nil;
    NSRange prefixRange = NSMakeRange(0, lastRange.location);
    NSString * prefix = [input substringWithRange:prefixRange];
    NSString * newInput =  [NSString stringWithFormat:@"%@_%@", prefix,
            [newValue stringByAddingStandardPercentEscapes]];
    return [[WAAssumptionValue alloc] initWithName:self.name
                                       description:self.description
                                             input:newInput
                                             valid:self.valid
                                        assumption:self.assumption];
}

@end
