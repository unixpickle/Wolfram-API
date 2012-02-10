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
@synthesize word;

- (id)initWithValues:(NSArray *)someValues attributes:(NSDictionary *)someAttributes {
    if ((self = [super init])) {
        values = someValues;
        type = [someAttributes objectForKey:@"type"];
        description = [someAttributes objectForKey:@"desc"];
        current = [someAttributes objectForKey:@"current"];
        word = [someAttributes objectForKey:@"word"];
    }
    return self;
}

- (id)initWithElement:(WAXMLNode *)node {
    if ((self = [super init])) {
        NSMutableArray * mValues = [[NSMutableArray alloc] init];
        for (WAXMLNode * subNode in [node elementsWithName:@"value"]) {
            WAAssumptionValue * value = [[WAAssumptionValue alloc] initWithNode:subNode assumption:self];
            [mValues addObject:value];
        }
        values = [[NSArray alloc] initWithArray:mValues];
        type = [node valueForAttribute:@"type"];
        description = [node valueForAttribute:@"desc"];
        word = [node valueForAttribute:@"word"];
        NSString * currentStr = [node valueForAttribute:@"current"];
        if (currentStr) current = [NSNumber numberWithInt:[currentStr intValue]];
    }
    return self;
}

- (WAAssumptionInputType)inputType {
    if ([values count] == 1 && [type isEqualToString:kAssumptionTypeFormulaVariable]) {
        return WAAssumptionInputTypeVariableCustom;
    } else if ([type isEqualToString:kAssumptionTypeFormulaVariable]) {
        return WAAssumptionInputTypeVariableList;
    }
    return WAAssumptionInputTypeList;
}

@end
