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

- (void)requestThread:(NSDictionary *)info;
- (void)requestAsyncPod:(NSURL *)asyncURL;

- (void)informDelegateResponse:(WAResponse *)response;
- (void)sendAsyncRequest:(NSString *)async;

@end

@implementation WAModel

@synthesize delegate;

- (id)init {
    if ((self = [super init])) {
        requestThreads = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)searchQuery:(NSString *)aQuery {
    [self cancelRequests];
    currentPage = [[WARequest alloc] initWithQuery:aQuery apiKey:kAPIKey assumptions:nil podStates:nil];
    
    NSDictionary * info = [NSDictionary dictionaryWithObject:currentPage forKey:kRequestInfoRequest];
    NSThread * requestThread = [[NSThread alloc] initWithTarget:self
                                                       selector:@selector(requestThread:)
                                                         object:info];
    @synchronized (requestThreads) {
        [requestThreads addObject:requestThread];
    }
    [requestThread start];
}

- (void)applyAssumption:(WAAssumptionValue *)assumption {
    [self cancelRequests];
    WAMutableRequest * mRequest = [currentPage mutableCopy];
    [mRequest selectAssumptionValue:assumption];
    currentPage = [mRequest copy];
    
    NSDictionary * info = [NSDictionary dictionaryWithObject:currentPage forKey:kRequestInfoRequest];
    NSThread * requestThread = [[NSThread alloc] initWithTarget:self
                                                       selector:@selector(requestThread:)
                                                         object:info];
    @synchronized (requestThreads) {
        [requestThreads addObject:requestThread];
    }
    [requestThread start];
}

- (void)applyState:(WAPodState *)state forPod:(WAPod *)aPod {
    WAMutableRequest * mRequest = [currentPage mutableCopy];
    [mRequest selectPodState:state];
    currentPage = [mRequest copy];

    NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:currentPage, kRequestInfoRequest,
                           [aPod identifier], kRequestInfoPod, nil];
    NSThread * requestThread = [[NSThread alloc] initWithTarget:self
                                                       selector:@selector(requestThread:)
                                                         object:info];
    @synchronized (requestThreads) {
        [requestThreads addObject:requestThread];
    }
    [requestThread start];
}

- (void)cancelRequests {
    @synchronized (requestThreads) {
        while ([requestThreads count] > 0) {
            NSThread * thread = [requestThreads lastObject];
            [thread cancel];
            [requestThreads removeLastObject];
        }
    }
}

#pragma mark - Background Threads -

- (void)requestThread:(NSDictionary *)info {
    
}

- (void)loadAsyncPod:(NSURL *)asyncURL {
    
}

@end
