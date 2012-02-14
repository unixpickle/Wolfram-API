//
//  WAResponse.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAResponse.h"

@interface WAResponse (Private)

- (BOOL)loadAssumptionsFromNode:(WAXMLNode *)node;
- (BOOL)loadPods:(NSArray *)nodes;

@end

@implementation WAResponse

@synthesize pods;
@synthesize assumptions;
@synthesize success;
@synthesize parseTimedOut;

- (id)initWithDocument:(WAXMLDocument *)document {
    if ((self = [super init])) {
        WAXMLNode * queryResult = [[document rootNode] elementWithName:@"queryresult"];
        NSString * successStr = [queryResult valueForAttribute:@"success"];
        NSString * parsedErrStr = [queryResult valueForAttribute:@"parsetimedout"];
        if ([parsedErrStr isEqualToString:@"true"]) {
            parseTimedOut = YES;
        }
        if ([successStr isEqualToString:@"false"]) {
            success = NO;
            return self;
        } else {
            success = YES;
        }
        WAXMLNode * assumpNode = [queryResult elementWithName:@"assumptions"];
        NSArray * podNodes = [queryResult elementsWithName:@"pod"];
        if (![self loadAssumptionsFromNode:assumpNode]) return nil;
        if (![self loadPods:podNodes]) return nil;
    }
    return self;
}

- (BOOL)loadAssumptionsFromNode:(WAXMLNode *)node {
    if (!node) return YES;
    NSMutableArray * mAssumptions = [[NSMutableArray alloc] init];
    NSArray * assumptionNodes = [node elementsWithName:@"assumption"];
    for (WAXMLNode * aNode in assumptionNodes) {
        WAAssumption * assumption = [[WAAssumption alloc] initWithElement:aNode];
        if (!assumption) return NO;
        [mAssumptions addObject:assumption];
    }
    assumptions = [[NSArray alloc] initWithArray:mAssumptions];
    return YES;
}

- (BOOL)loadPods:(NSArray *)nodes {
    if (!nodes) return NO;
    NSMutableArray * mPods = [[NSMutableArray alloc] init];
    for (WAXMLNode * aNode in nodes) {
        WAPod * pod = [[WAPod alloc] initWithElement:aNode];
        if (!pod) return NO;
        [mPods addObject:pod];
    }
    pods = [[NSArray alloc] initWithArray:mPods];
    return YES;
}

@end
