//
//  WAViewEvent.m
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewEvent.h"

@implementation WAViewEvent

@synthesize eventType;
@synthesize userInfo;

- (id)initWithEventType:(WAViewEventType)type userInfo:(NSDictionary *)info {
    if ((self = [super init])) {
        eventType = type;
        userInfo = info;
    }
    return self;
}

@end
