//
//  WAResponse.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAResponse.h"

@interface WAResponse (Private)

- (void)loadAssumptionsFromNode:(WAXMLNode *)node;

@end

@implementation WAResponse

@synthesize pods;
@synthesize assumptions;

- (id)initWithDocument:(WAXMLDocument *)document {
    if ((self = [super init])) {
        WAXMLNode * queryResult = [[document rootNode] elementWithName:@"queryresult"];
        WAXMLNode * assumpNode = [queryResult elementWithName:@"assumptions"];
        [self loadAssumptionsFromNode:assumpNode];
    }
    return self;
}

- (void)loadAssumptionsFromNode:(WAXMLNode *)node {
    if (!node) return;
    NSMutableArray * assumptionsMutable = [[NSMutableArray alloc] init];
    NSArray * assumptionNodes = [node elementsWithName:@"assumption"];
    for (WAXMLNode * aNode in assumptionNodes) {
        WAAssumption * assumption = [[WAAssumption alloc] initWithElement:aNode];
        [assumptionsMutable addObject:assumption];
    }
    assumptions = [[NSArray alloc] initWithArray:assumptionsMutable];
}

@end
