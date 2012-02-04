//
//  WAMutableRequest.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAMutableRequest.h"

@implementation WAMutableRequest

- (void)setQuery:(NSString *)aQuery {
    query = aQuery;
}

- (void)setAPIKey:(NSString *)aKey {
    APIKey = aKey;
}

- (void)addAssumption:(WARequestAssumption *)assumption {
    assumptions = [assumptions arrayByAddingObject:assumption];
}

- (void)addPodState:(WARequestPodState *)podState {
    podStates = [podStates arrayByAddingObject:podStates];
}

- (void)removeAssumption:(WARequestAssumption *)assumption {
    NSMutableArray * array = [assumptions mutableCopy];
    [array removeObject:assumption];
    assumptions = [NSArray arrayWithArray:array];
}

- (void)removePodState:(WARequestPodState *)podState {
    NSMutableArray * array = [podStates mutableCopy];
    [array removeObject:podState];
    podStates = [NSArray arrayWithArray:array];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[WARequest alloc] initWithQuery:query apiKey:APIKey assumptions:assumptions podStates:podStates];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[WAMutableRequest alloc] initWithQuery:query apiKey:APIKey assumptions:assumptions podStates:podStates];
}

@end
