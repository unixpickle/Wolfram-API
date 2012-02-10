//
//  WASubPod.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WASubPod.h"

@implementation WASubPod

@synthesize title;
@synthesize representations;
@synthesize podStates;
@synthesize pod;

- (id)initWithElement:(WAXMLNode *)node pod:(WAPod *)parentPod {
    if ((self = [super init])) {
        pod = parentPod;
        NSMutableArray * mRepresentations = [[NSMutableArray alloc] init];
        WAXMLNode * textNode = [node elementWithName:@"plaintext"];
        if (textNode) {
            NSString * string = [textNode stringContents];
            WAPlainText * plain = [[WAPlainText alloc] initWithText:string];
            [mRepresentations addObject:plain];
        }
        representations = [[NSArray alloc] initWithArray:mRepresentations];
        WAXMLNode * statesElement = [node elementWithName:@"states"];
        if (statesElement) podStates = [WAPodState podStatesFromElement:statesElement pod:parentPod];
    }
    return self;
}

@end
