//
//  WAModel.m
//  Wolfram
//
//  Created by Nichol, Alexander on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAModel.h"

#define kRequestInfoRequest @"kRequestInfoRequest"
#define kRequestInfoPod @"kRequestInfoPod"

@interface WAModel (Private)

- (void)delegateInformError:(NSError *)fetchError;
- (void)delegateInformResponse:(WAResponse *)response;
- (void)delegateInformPod:(WAPod *)aPod;
- (void)delegateInformComplete;
- (void)sendPrimaryRequest:(NSString *)podID;
- (void)sendAsyncRequest:(NSURL *)async;

@end

@implementation WAModel

@synthesize delegate;

- (id)init {
    if ((self = [super init])) {
        requests = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)searchQuery:(NSString *)aQuery {
    [self cancelRequests];
    currentPage = [[WARequest alloc] initWithQuery:aQuery apiKey:kAPIKey assumptions:nil podStates:nil];
    
    [self sendPrimaryRequest:nil];
}

- (void)applyAssumption:(WAAssumptionValue *)assumption {
    [self cancelRequests];
    WAMutableRequest * mRequest = [currentPage mutableCopy];
    [mRequest selectAssumptionValue:assumption];
    currentPage = [mRequest copy];
    
    [self sendPrimaryRequest:nil];
}

- (void)applyState:(WAPodState *)state forPod:(WAPod *)aPod {
    WAMutableRequest * mRequest = [currentPage mutableCopy];
    [mRequest selectPodState:state];
    currentPage = [mRequest copy];
    
    [self sendPrimaryRequest:[aPod identifier]];
}

- (void)cancelRequests {
    while ([requests count] > 0) {
        WAModelRequest * request = [requests lastObject];
        [request cancel];
        [requests removeLastObject];
    }
}

- (BOOL)isFinished {
    return [requests count] == 0;
}

#pragma mark - Requests -

- (void)delegateInformError:(NSError *)fetchError {
    if ([delegate respondsToSelector:@selector(model:failedToLoad:)]) {
        [delegate model:self failedToLoad:fetchError];
    }
}

- (void)delegateInformResponse:(WAResponse *)response {
    if ([delegate respondsToSelector:@selector(model:gotResponse:)]) {
        [delegate model:self gotResponse:response];
    }
    if ([delegate respondsToSelector:@selector(model:gotAssumptions:)]) {
        [delegate model:self gotAssumptions:[response assumptions]];
    }
    for (WAPod * pod in [response pods]) {
        if ([[pod subPods] count] > 0) {
            if ([delegate respondsToSelector:@selector(model:gotPod:)]) {
                [delegate model:self gotPod:pod];
            }
        } else {
            // detatch async if it is possible
            if ([pod asyncURL]) {
                [self sendAsyncRequest:[pod asyncURL]];
            } else {
                NSLog(@"Invalid pod with no async: %@", [pod identifier]);
            }
        }
    }
    if ([requests count] == 0) {
        [self delegateInformComplete];
    }
}

- (void)delegateInformPod:(WAPod *)aPod {
    if ([delegate respondsToSelector:@selector(model:gotPod:)]) {
        [delegate model:self gotPod:aPod];
    }
}

- (void)delegateInformComplete {
    if ([delegate respondsToSelector:@selector(modelFinishedAllQueries:)]) {
        [delegate modelFinishedAllQueries:self];
    }
}

- (void)sendPrimaryRequest:(NSString *)podID {
    WAModelQuery * query = [[WAModelQuery alloc] initWithRequest:[currentPage copy]
                                                           podID:podID];
    [query setDelegate:self];
    [requests addObject:query];
    [query start];
}

- (void)sendAsyncRequest:(NSURL *)async {
    WAModelPodQuery * podQuery = [[WAModelPodQuery alloc] initWithURL:async];
    [podQuery setDelegate:self];
    [requests addObject:podQuery];
    [podQuery start];
}

- (void)modelRequest:(id)sender failedWithError:(NSError *)anError {
    [requests removeObject:sender];
    [self delegateInformError:anError];
}

- (void)modelRequest:(id)sender fetchedObject:(id)object {
    [requests removeObject:sender];
    if ([sender isKindOfClass:[WAModelQuery class]]) {
        WAModelQuery * query = (WAModelQuery *)sender;
        WAResponse * response = (WAResponse *)object;
        if ([query podID]) {
            // specific pod request => treat like async
            for (WAPod * pod in [response pods]) {
                [self delegateInformPod:pod];
            }
            if ([requests count] == 0) {
                [self delegateInformComplete];
            }
        } else {
            [self delegateInformResponse:response];
        }
    } else if ([sender isKindOfClass:[WAModelPodQuery class]]) {
        WAPod * pod = (WAPod *)object;
        [self delegateInformPod:pod];
        if ([requests count] == 0) {
            [self delegateInformComplete];
        }
    }
}

@end
