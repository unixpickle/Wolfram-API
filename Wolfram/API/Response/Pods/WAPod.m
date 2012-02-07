//
//  WAPod.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAPod.h"

@interface WAPod (Private)

- (void)loadStates:(WAXMLNode *)statesElement;

@end

@implementation WAPod

@synthesize title;
@synthesize scanner;
@synthesize identifier;
@synthesize error;
@synthesize subPods;
@synthesize podStates;

- (id)initWithElement:(WAXMLNode *)node {
    if ((self = [super init])) {
        title = [node valueForAttribute:@"title"];
        scanner = [node valueForAttribute:@"scanner"];
        identifier = [node valueForAttribute:@"id"];
        error = [node valueForAttribute:@"error"];
        
        NSArray * podElements = [node elementsWithName:@"subpod"];
        NSMutableArray * mSubPods = [[NSMutableArray alloc] init];
        for (WAXMLNode * node in podElements) {
            WASubPod * subPod = [[WASubPod alloc] initWithElement:node];
            if (!subPod) return nil;
            [mSubPods addObject:subPod];
        }
        subPods = [[NSArray alloc] initWithArray:mSubPods];
        
        WAXMLNode * statesElement = [node elementWithName:@"states"];
        if (statesElement) [self loadStates:statesElement];
    }
    return self;
}

- (void)loadStates:(WAXMLNode *)statesElement {
    NSArray * states = [statesElement elementsWithName:@"state"];
    NSArray * lists = [statesElement elementsWithName:@"statelist"];
    NSMutableArray * mPodStates = [[NSMutableArray alloc] init];
    for (WAXMLNode * node in states) {
        WAPodState * podState = [[WAPodState alloc] initWithElement:node list:nil];
        [mPodStates addObject:podState];
    }
    for (WAXMLNode * node in lists) {
        WAPodStateList * list = [[WAPodStateList alloc] initWithElement:node];
        [mPodStates addObject:list];
    }
    podStates = [[NSArray alloc] initWithArray:mPodStates];
}

@end
