//
//  WAEventManager.m
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAEventManager.h"

@implementation WAEventManager

@synthesize target;

- (id)initWithTarget:(id<WAEventManagerTarget>)aTarget {
    if ((self = [super init])) {
        target = aTarget;
    }
    return self;
}

- (void)postEvent:(WAEvent *)event {
    [target eventManager:self receivedEvent:event];
}

@end
