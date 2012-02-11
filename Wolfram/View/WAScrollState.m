//
//  WAScrollState.m
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAScrollState.h"

@implementation WAScrollState

@synthesize visibleRect;
@synthesize contentHeight;

- (id)initWithVisibleRect:(NSRect)vRect contentHeight:(CGFloat)height {
    if ((self = [super init])) {
        visibleRect = vRect;
        contentHeight = height;
    }
    return self;
}

@end
