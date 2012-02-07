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
    }
    return self;
}

- (NSURL *)encodedURL {
    return [self encodedURLForIncludeIDs:nil];
}

- (NSURL *)encodedURLForIncludeIDs:(NSArray *)podIDs {
    NSString * baseStr = @"http://api.wolframalpha.com/v2/query?input=%@&appid=%@";
    NSMutableString * builtRequest = [NSMutableString stringWithFormat:baseStr,
                                      [query stringByAddingStandardPercentEscapes],
                                      [APIKey stringByAddingStandardPercentEscapes]];
    for (NSString * assumption in assumptions) {
        [builtRequest appendFormat:@"&assumption=%@", [assumption stringByAddingStandardPercentEscapes]];
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
