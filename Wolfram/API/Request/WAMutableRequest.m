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

- (void)addAssumption:(NSString *)assumption {
    assumptions = [assumptions arrayByAddingObject:assumption];
}

- (void)addPodState:(NSString *)podState {
    podStates = [podStates arrayByAddingObject:podStates];
}

- (void)removeAssumption:(NSString *)assumption {
    NSMutableArray * array = [assumptions mutableCopy];
    [array removeObject:assumption];
    assumptions = [NSArray arrayWithArray:array];
}

- (void)removePodState:(NSString *)podState {
    NSMutableArray * array = [podStates mutableCopy];
    [array removeObject:podState];
    podStates = [NSArray arrayWithArray:array];
}

- (void)selectAssumptionValue:(WAAssumptionValue *)value {
    // remove all existing values from the assumption
    WAAssumption * assumption = [value assumption];
    NSMutableArray * mAssumptions = [assumptions mutableCopy];
    for (WAAssumptionValue * aValue in [assumption values]) {
        if ([mAssumptions containsObject:[aValue input]]) {
            [mAssumptions removeObject:[aValue input]];
        }
    }
    // add this new value from the assumption
    [mAssumptions addObject:[value input]];
    assumptions = [NSArray arrayWithArray:mAssumptions];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[WARequest alloc] initWithQuery:query apiKey:APIKey assumptions:assumptions podStates:podStates];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[WAMutableRequest alloc] initWithQuery:query apiKey:APIKey assumptions:assumptions podStates:podStates];
}

@end
