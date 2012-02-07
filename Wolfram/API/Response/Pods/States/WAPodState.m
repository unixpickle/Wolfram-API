//
//  WAPodState.m
//  Wolfram
//
//  Created by Nichol, Alexander on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAPodState.h"
#import "WAPodStateList.h"

@implementation WAPodState

@synthesize parentList;
@synthesize name;
@synthesize input;

+ (NSArray *)podStatesFromElement:(WAXMLNode *)element {
    NSArray * states = [element elementsWithName:@"state"];
    NSArray * lists = [element elementsWithName:@"statelist"];
    NSMutableArray * mPodStates = [[NSMutableArray alloc] init];
    for (WAXMLNode * node in states) {
        WAPodState * podState = [[WAPodState alloc] initWithElement:node list:nil];
        [mPodStates addObject:podState];
    }
    for (WAXMLNode * node in lists) {
        WAPodStateList * list = [[WAPodStateList alloc] initWithElement:node];
        [mPodStates addObject:list];
    }
    return [[NSArray alloc] initWithArray:mPodStates];
}

- (id)initWithName:(NSString *)aName input:(NSString *)theInput list:(WAPodStateList *)parent {
    if ((self = [super init])) {
        parentList = parent;
        name = aName;
        input = theInput;
    }
    return self;
}

- (id)initWithElement:(WAXMLNode *)node list:(WAPodStateList *)parent {
    if ((self = [super init])) {
        name = [node valueForAttribute:@"name"];
        input = [node valueForAttribute:@"input"];
        parentList = parent;
    }
    return self;
}

- (NSString *)encodeInput {
    return [input stringByAddingStandardPercentEscapes];
}

@end
