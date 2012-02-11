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
        WAXMLNode * imageNode = [node elementWithName:@"img"];
        if (textNode) {
            NSString * string = [textNode stringContents];
            WAPlainText * plain = [[WAPlainText alloc] initWithText:string];
            [mRepresentations addObject:plain];
        }
        if (imageNode) {
            WAImage * image = [[WAImage alloc] initWithElement:imageNode];
            [mRepresentations addObject:image];
        }
        representations = [[NSArray alloc] initWithArray:mRepresentations];
        WAXMLNode * statesElement = [node elementWithName:@"states"];
        if (statesElement) podStates = [WAPodState podStatesFromElement:statesElement pod:parentPod];
    }
    return self;
}

- (id)representationOfClass:(Class)aClass {
    for (id obj in representations) {
        if ([obj isKindOfClass:aClass]) {
            return obj;
        }
    }
    return nil;
}

- (WAImage *)imageRepresentation {
    return [self representationOfClass:[WAImage class]];
}

@end
