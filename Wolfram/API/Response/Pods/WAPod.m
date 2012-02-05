//
//  WAPod.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAPod.h"

@implementation WAPod

@synthesize title;
@synthesize scanner;
@synthesize identifier;
@synthesize error;
@synthesize subPods;

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
    }
    return self;
}

@end
