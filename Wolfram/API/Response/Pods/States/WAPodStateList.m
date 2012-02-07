//
//  WAPodStateList.m
//  Wolfram
//
//  Created by Nichol, Alexander on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAPodStateList.h"

@implementation WAPodStateList

@synthesize podStates;

- (id)initWithStates:(NSArray *)states {
    if ((self = [super init])) {
        podStates = states;
    }
    return self;
}

- (id)initWithElement:(WAXMLNode *)node {
    if ((self = [super init])) {
        NSMutableArray * mStates = [[NSMutableArray alloc] init];
        NSArray * elStates = [node elementsWithName:@"state"];
        for (WAXMLNode * state in elStates) {
            WAPodState * podState = [[WAPodState alloc] initWithElement:state list:self];
            [mStates addObject:podState];
        }
        podStates = [[NSArray alloc] initWithArray:mStates];
    }
    return self;
}

@end
