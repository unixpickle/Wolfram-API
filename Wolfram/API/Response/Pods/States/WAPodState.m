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
