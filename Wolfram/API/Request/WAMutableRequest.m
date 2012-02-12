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

- (void)addPodState:(NSString *)podState {
    podStates = [podStates arrayByAddingObject:podStates];
}

- (void)removeAssumption:(WARequestAssumption *)assumption {
    NSMutableArray * array = [assumptions mutableCopy];
    for (NSInteger i = 0; i < [array count]; i++) {
        WARequestAssumption * value = [array objectAtIndex:i];
        if ([[value input] isEqualToString:[assumption input]]) {
            [array removeObjectAtIndex:i];
            i--;
        }
    }
    assumptions = [NSArray arrayWithArray:array];
}

- (void)removePodState:(NSString *)podState {
    NSMutableArray * array = [podStates mutableCopy];
    [array removeObject:podState];
    podStates = [NSArray arrayWithArray:array];
}


#pragma mark - Selecting -

- (void)removeConflicting:(WARequestAssumption *)assumption {
    NSMutableArray * array = [assumptions mutableCopy];
    for (NSInteger i = 0; i < [array count]; i++) {
        WARequestAssumption * value = [array objectAtIndex:i];
        BOOL conflict = [value conflictsWithAssumption:assumption];
        if (conflict) {
            [array removeObjectAtIndex:i];
            i--;
        }
    }
    assumptions = [NSArray arrayWithArray:array];
}

- (void)selectAssumptionValue:(WAAssumptionValue *)value {
    WARequestAssumption * assumption = [[WARequestAssumption alloc] initWithAssumptionValue:value];
    [self removeConflicting:assumption];
    [self addAssumption:assumption];
}

- (void)selectPodState:(WAPodState *)podState {
    WAPodStateList * list = [podState parentList];
    NSMutableArray * mList = [podStates mutableCopy];
    if (list) {
        for (WAPodState * state in [list podStates]) {
            if ([mList containsObject:[state input]]) {
                [mList removeObject:[state input]];
            }
        }
    }
    [mList addObject:[podState encodeInput]];
    podStates = [[NSArray alloc] initWithArray:mList];
}

#pragma mark - Copying -

- (id)copyWithZone:(NSZone *)zone {
    return [[WARequest alloc] initWithQuery:query apiKey:APIKey assumptions:assumptions podStates:podStates];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[WAMutableRequest alloc] initWithQuery:query apiKey:APIKey assumptions:assumptions podStates:podStates];
}

@end
