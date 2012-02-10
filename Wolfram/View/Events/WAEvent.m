//
//  WAEvent.m
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAEvent.h"

@implementation WAEvent

@synthesize eventType = _eventType;
@synthesize userInfo = _userInfo;
@synthesize sender = _sender;

- (id)initWithEventType:(WAEventType)eventType sender:(id)sender userInfo:(NSDictionary *)userInfo {
    if ((self = [super init])) {
        _eventType = eventType;
        _userInfo = userInfo;
        _sender = sender;
    }
    return self;
}

- (id)initWithEventType:(WAEventType)eventType sender:(id)sender object:(id)obj forKey:(NSString *)key {
    NSDictionary * info = [NSDictionary dictionaryWithObject:obj forKey:key];
    self = [self initWithEventType:eventType sender:sender userInfo:info];
    return self;
}

+ (WAEvent *)eventWithType:(WAEventType)eventType sender:(id)sender userInfo:(NSDictionary *)userInfo {
    return [[WAEvent alloc] initWithEventType:eventType sender:sender userInfo:userInfo];
}

+ (WAEvent *)eventWithType:(WAEventType)eventType sender:(id)sender object:(id)obj forKey:(NSString *)key {
    return [[WAEvent alloc] initWithEventType:eventType sender:sender object:obj forKey:key];
}

+ (WAEvent *)eventWithType:(WAEventType)eventType sender:(id)sender {
    return [[WAEvent alloc] initWithEventType:eventType sender:sender userInfo:nil];
}

@end
