//
//  WARequestPodState.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WARequestPodState.h"

@implementation WARequestPodState

@synthesize podName;
@synthesize subPodName;
@synthesize state;

- (id)initWithPod:(NSString *)pod subPod:(NSString *)subPod state:(NSString *)aState {
    if ((self = [super init])) {
        podName = pod;
        subPodName = subPod;
        state = aState;
    }
    return self;
}

- (id)initWithPod:(NSString *)pod state:(NSString *)aState {
    self = [self initWithPod:pod subPod:nil state:aState];
    return self;
}

+ (id)requestPodWithPod:(NSString *)pod subPod:(NSString *)subPod state:(NSString *)aState {
    return [[WARequestPodState alloc] initWithPod:pod subPod:subPod state:aState];
}

+ (id)requestPodWithPod:(NSString *)pod state:(NSString *)aState {
    return [[WARequestPodState alloc] initWithPod:pod state:aState];
}

- (NSString *)encodedString {
    if (!subPodName) {
        return [NSString stringWithFormat:@"%@__%@",
                [podName stringByAddingStandardPercentEscapes],
                [state stringByAddingStandardPercentEscapes]];
    }
    return [NSString stringWithFormat:@"%@__%@_%@",
            [podName stringByAddingStandardPercentEscapes],
            [subPodName stringByAddingStandardPercentEscapes],
            [state stringByAddingStandardPercentEscapes]];
}

@end
