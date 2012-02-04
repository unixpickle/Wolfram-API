//
//  WARequestAssumption.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WARequestAssumption.h"

@implementation WARequestAssumption

@synthesize assumptionName;
@synthesize assumptionValue;

- (id)initWithName:(NSString *)name value:(NSString *)value {
    if ((self = [super init])) {
        assumptionName = name;
        assumptionValue = value;
    }
    return self;
}

- (id)initWithAssumptionString:(NSString *)string {
    if ((self = [super init])) {
        NSArray * components = [string componentsSeparatedByString:@"_"];
        if ([components count] != 2) return nil;
        assumptionName = [[components objectAtIndex:0] stringByEvaluatingPercentEscapes];
        assumptionValue = [[components objectAtIndex:1] stringByEvaluatingPercentEscapes];
    }
    return self;
}

+ (id)requestAssumptionWithName:(NSString *)name value:(NSString *)value {
    return [[WARequestAssumption alloc] initWithName:name value:value];
}

- (NSString *)encodedString {
    return [NSString stringWithFormat:@"%@_%@", [assumptionName stringByAddingStandardPercentEscapes],
            [assumptionValue stringByAddingStandardPercentEscapes]];
}

@end
