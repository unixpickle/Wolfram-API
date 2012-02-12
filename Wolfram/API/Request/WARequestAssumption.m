//
//  WARequestAssumption.m
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WARequestAssumption.h"

@implementation WARequestAssumption

@synthesize name;
@synthesize input;

- (id)initWithName:(NSString *)theName
             input:(NSString *)theInput {
    if ((self = [super init])) {
        name = theName;
        input = theInput;
    }
    return self;
}

- (id)initWithAssumptionValue:(WAAssumptionValue *)value {
    self = [self initWithName:[value name]
                        input:[value input]];
    return self;
}

- (NSString *)inputPrefix {
    NSRange range = [input rangeOfString:@"_"];
    if (range.location == NSNotFound) return input;
    return [input substringToIndex:range.location];
}

- (BOOL)conflictsWithAssumption:(WARequestAssumption *)anAssumption {
    return [[self inputPrefix] isEqualToString:[anAssumption inputPrefix]];
}

@end
