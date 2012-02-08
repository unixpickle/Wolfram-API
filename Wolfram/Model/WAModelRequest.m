//
//  WAModelRequest.m
//  Wolfram
//
//  Created by Alex Nichol on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAModelRequest.h"

@implementation WAModelRequest

@synthesize delegate = delegate;

- (void)start {
    if (backgroundThread) {
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:@"Already started."
                                     userInfo:nil];
    }
    backgroundThread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(backgroundMethod)
                                                 object:nil];
    [backgroundThread start];
}

- (void)cancel {
    [backgroundThread cancel];
    backgroundThread = nil;
}

- (void)backgroundThread {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"This is an abstract class and must be subclassed."
                                 userInfo:nil];
}

+ (WAXMLDocument *)fetchXMLDocument:(NSURL *)aURL error:(NSError **)error {
    // fetch the URL data
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:aURL];
    NSData * fetched = [NSURLConnection sendSynchronousRequest:urlRequest
                                             returningResponse:nil error:error];
    if ([[NSThread currentThread] isCancelled]) return nil;
    if (!fetched) return nil;
    
    // parse the XML document
    WAXMLDocument * document = [[WAXMLDocument alloc] initWithXMLData:fetched];
    if (!document) {
        *error = [NSError errorWithDomain:@"WAXMLDocument"
                                     code:1
                                  message:@"Failed to parse response."];
        return nil;
    }
    return document;
}

- (void)delegateInformError:(NSError *)error {
    if (![[NSThread currentThread] isMainThread]) {
        if ([[NSThread currentThread] isCancelled]) {
            backgroundThread = nil;
            return;
        }
        [self performSelectorOnMainThread:@selector(delegateInformError:) withObject:error waitUntilDone:NO];
        return;
    }
    if ([delegate respondsToSelector:@selector(modelRequest:failedWithError:)]) {
        [delegate modelRequest:self failedWithError:error];
    }
    backgroundThread = nil;
}

- (void)delegateInformResult:(id)object {
    if (![[NSThread currentThread] isMainThread]) {
        if ([[NSThread currentThread] isCancelled]) {
            backgroundThread = nil;
            return;
        }
        [self performSelectorOnMainThread:@selector(delegateInformResult:) withObject:object waitUntilDone:NO];
        return;
    }
    if ([delegate respondsToSelector:@selector(modelRequest:fetchedObject:)]) {
        [delegate modelRequest:self fetchedObject:object];
    }
    backgroundThread = nil;
}

@end
