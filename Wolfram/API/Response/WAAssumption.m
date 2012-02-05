//
//  WAAssumption.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAssumption.h"

@implementation WAAssumption

@synthesize values;
@synthesize type;
@synthesize description;
@synthesize current;
@synthesize count;
@synthesize word;

- (id)initWithValues:(NSArray *)someValues attributes:(NSDictionary *)someAttributes {
    if ((self = [super init])) {
        values = someValues;
        type = [someAttributes objectForKey:@"type"];
        description = [someAttributes objectForKey:@"desc"];
        current = [someAttributes objectForKey:@"current"];
        count = [someAttributes objectForKey:@"count"];
        word = [someAttributes objectForKey:@"word"];
    }
    return self;
}

- (id)initWithElement:(WAXMLNode *)node {
    if ((self = [super init])) {
        NSMutableArray * mValues = [[NSMutableArray alloc] init];
        for (WAXMLNode * subNode in [node elementsWithName:@"value"]) {
            WAAssumptionValue * value = [[WAAssumptionValue alloc] initWithNode:subNode];
            [mValues addObject:value];
        }
        values = [[NSArray alloc] initWithArray:mValues];
        type = [node valueForAttribute:@"type"];
        description = [node valueForAttribute:@"desc"];
        word = [node valueForAttribute:@"word"];
        NSString * currentStr = [node valueForAttribute:@"current"];
        NSString * countStr = [node valueForAttribute:@"count"];
        if (currentStr) current = [NSNumber numberWithInt:[currentStr intValue]];
        if (countStr) count = [NSNumber numberWithInt:[countStr intValue]];
    }
    return self;
}

- (WAAssumptionInputType)inputType {
    if ([count intValue] == 1) {
        return WAAssumptionInputTypeCustom;
    } else if ([count intValue] > 2) {
        return WAAssumptionInputTypeList;
    }
    return WAAssumptionInputTypeLink;
}

@end
