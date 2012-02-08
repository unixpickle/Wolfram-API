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

- (NSError *)errorWithDomain:(NSString *)domain code:(NSUInteger)code message:(NSString *)msg;

- (void)requestThread:(NSDictionary *)info;
- (void)requestAsyncPod:(NSURL *)asyncURL;
- (void)removeCurrentThread;

- (void)informDelegateError:(NSError *)fetchError;
- (void)informDelegateResponse:(WAResponse *)response;
- (void)informDelegatePod:(WAPod *)aPod;
- (void)sendPrimaryRequest:(NSString *)podID;
- (void)sendAsyncRequest:(NSURL *)async;

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
    @synchronized (requestThreads) {
        while ([requestThreads count] > 0) {
            NSThread * thread = [requestThreads lastObject];
            [thread cancel];
            [requestThreads removeLastObject];
        }
    }
}

#pragma mark - Background Threads -

- (NSError *)errorWithDomain:(NSString *)domain code:(NSUInteger)code message:(NSString *)msg {
    NSDictionary * info = [NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:domain code:code userInfo:info];
}

- (void)requestThread:(NSDictionary *)info {
    @autoreleasepool {
        WARequest * request = [info objectForKey:kRequestInfoRequest];
        NSString * podName = [info objectForKey:kRequestInfoPod];
        NSURL * url = nil;
        if (podName) url = [request encodedURL:kUseAsync forIncludeIDs:[NSArray arrayWithObject:podName]];
        else url = [request encodedURL:kUseAsync];
        
        // fetch the URL data
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
        NSError * error = nil;
        NSData * fetched = [NSURLConnection sendSynchronousRequest:urlRequest
                                                 returningResponse:nil error:&error];
        if ([[NSThread currentThread] isCancelled]) return;
        if (!fetched) {
            [self performSelectorOnMainThread:@selector(informDelegateError:)
                                   withObject:error waitUntilDone:NO];
            [self removeCurrentThread];
            return;
        }
        
        // parse the XML document
        WAXMLDocument * document = [[WAXMLDocument alloc] initWithXMLData:fetched];
        if (!document) {
            NSError * xmlError = [self errorWithDomain:@"WAXMLDocument"
                                                  code:1
                                               message:@"Failed to parse response."];
            [self performSelectorOnMainThread:@selector(informDelegateError:)
                                   withObject:xmlError waitUntilDone:NO];
            [self removeCurrentThread];
            return;
        }
        
        // process the XML as a response
        WAResponse * response = [[WAResponse alloc] initWithDocument:document];
        if (!response) {
            NSError * waError = [self errorWithDomain:@"WAResponse"
                                                  code:1
                                               message:@"Invalid response XML"];
            [self performSelectorOnMainThread:@selector(informDelegateError:)
                                   withObject:waError waitUntilDone:NO];
            [self removeCurrentThread];
            return;
        }
        
        [self performSelectorOnMainThread:@selector(informDelegateResponse:)
                               withObject:response waitUntilDone:NO];
        [self removeCurrentThread];
    }
}

- (void)requestAsyncPod:(NSURL *)asyncURL {
    @autoreleasepool {
        // fetch the URL data
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:asyncURL];
        NSError * error = nil;
        NSData * fetched = [NSURLConnection sendSynchronousRequest:urlRequest
                                                 returningResponse:nil error:&error];
        if ([[NSThread currentThread] isCancelled]) return;
        if (!fetched) {
            [self performSelectorOnMainThread:@selector(informDelegateError:)
                                   withObject:error waitUntilDone:NO];
            [self removeCurrentThread];
            return;
        }
        
        // parse the XML document
        WAXMLDocument * document = [[WAXMLDocument alloc] initWithXMLData:fetched];
        if (!document) {
            NSError * xmlError = [self errorWithDomain:@"WAXMLDocument"
                                                  code:1
                                               message:@"Failed to parse response."];
            [self performSelectorOnMainThread:@selector(informDelegateError:)
                                   withObject:xmlError waitUntilDone:NO];
            [self removeCurrentThread];
            return;
        }
        
        // process the XML as a pod
        WAXMLNode * podNode = [[document rootNode] elementWithName:@"pod"];
        WAPod * pod = [[WAPod alloc] initWithElement:podNode];
        if (!pod) {
            NSError * podError = [self errorWithDomain:@"WAPod"
                                                  code:1
                                               message:@"Failed to parse response pod."];
            [self performSelectorOnMainThread:@selector(informDelegateError:)
                                   withObject:podError waitUntilDone:NO];
            [self removeCurrentThread];
            return;
        }
        
        [self performSelectorOnMainThread:@selector(informDelegatePod:)
                               withObject:pod waitUntilDone:NO];
        [self removeCurrentThread];
    }
}

- (void)removeCurrentThread {
    NSThread * thread = [NSThread currentThread];
    @synchronized (requestThreads) {
        [requestThreads removeObject:thread];
    }
}

- (void)informDelegateError:(NSError *)fetchError {
    if ([delegate respondsToSelector:@selector(model:failedToLoad:)]) {
        [delegate model:self failedToLoad:fetchError];
    }
}

- (void)informDelegateResponse:(WAResponse *)response {
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
}

- (void)informDelegatePod:(WAPod *)aPod {
    if ([delegate respondsToSelector:@selector(model:gotPod:)]) {
        [delegate model:self gotPod:aPod];
    }
}

- (void)sendPrimaryRequest:(NSString *)podID {
    NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:[currentPage copy], kRequestInfoRequest,
                           podID, kRequestInfoPod, nil];
    NSThread * requestThread = [[NSThread alloc] initWithTarget:self
                                                       selector:@selector(requestThread:)
                                                         object:info];
    @synchronized (requestThreads) {
        [requestThreads addObject:requestThread];
    }
    [requestThread start];
}

- (void)sendAsyncRequest:(NSURL *)async {
    NSThread * requestThread = [[NSThread alloc] initWithTarget:self
                                                       selector:@selector(requestAsyncPod:)
                                                         object:async];
    @synchronized (requestThreads) {
        [requestThreads addObject:requestThread];
    }
    [requestThread start];
}

@end
