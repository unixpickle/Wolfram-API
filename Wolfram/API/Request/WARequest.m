//
//  WARequest.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WARequest.h"
#import "WAMutableRequest.h"

@implementation WARequest

@synthesize podStates;
@synthesize assumptions;
@synthesize APIKey;
@synthesize query;

- (id)initWithQuery:(NSString *)theQuery apiKey:(NSString *)theKey
        assumptions:(NSArray *)theAssumptions podStates:(NSArray *)theStates {
    if ((self = [super init])) {
        query = theQuery;
        APIKey = theKey;
        podStates = theStates;
        assumptions = theAssumptions;
        if (!assumptions) {
            assumptions = [NSArray array];
        }
        if (!podStates) {
            podStates = [NSArray array];
        }
    }
    return self;
}

- (NSURL *)encodedURL:(BOOL)async {
    return [self encodedURL:async forIncludeIDs:nil];
}

- (NSURL *)encodedURL:(BOOL)async forIncludeIDs:(NSArray *)podIDs {
    NSString * baseStr = @"http://api.wolframalpha.com/v2/query?input=%@&appid=%@%@";
    NSMutableString * builtRequest = [NSMutableString stringWithFormat:baseStr,
                                      [query stringByAddingStandardPercentEscapes],
                                      [APIKey stringByAddingStandardPercentEscapes],
                                      (async ? @"&async=true" : @"")];
    for (WARequestAssumption * assumption in assumptions) {
        NSString * input = [assumption input];
        [builtRequest appendFormat:@"&assumption=%@", input];
    }
    for (NSString * podState in podStates) {
        [builtRequest appendFormat:@"&podstate=%@", [podState stringByAddingStandardPercentEscapes]];
    }
    if (podIDs) {
        for (NSString * anID in podIDs) {
            [builtRequest appendFormat:@"&includepodid=%@",
             [anID stringByAddingStandardPercentEscapes]];
        }
    }
    return [NSURL URLWithString:builtRequest];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[WARequest allocWithZone:zone] initWithQuery:query apiKey:APIKey
                                             assumptions:assumptions podStates:podStates];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[WAMutableRequest allocWithZone:zone] initWithQuery:query apiKey:APIKey
                                                    assumptions:assumptions podStates:podStates];
}

@end
