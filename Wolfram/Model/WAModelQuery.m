//
//  WAModelQuery.m
//  Wolfram
//
//  Created by Alex Nichol on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAModelQuery.h"

@implementation WAModelQuery

@synthesize podID;

- (id)initWithRequest:(WARequest *)aRequest podID:(NSString *)aPodID {
    if ((self = [super init])) {
        request = aRequest;
        podID = aPodID;
    }
    return self;
}

- (void)backgroundMethod {
    @autoreleasepool {
        NSURL * url = nil;
        if (podID) {
            url = [request encodedURL:kUseAsync forIncludeIDs:[NSArray arrayWithObject:podID]];
        } else {
            url = [request encodedURL:kUseAsync];
        }
        
        NSError * error = nil;
        WAXMLDocument * document = [[self class] fetchXMLDocument:url error:&error];
        if ([[NSThread currentThread] isCancelled]) return;
        if (!document) {
            [self delegateInformError:error];
            return;
        }
        
        // process the XML as a response
        WAResponse * response = [[WAResponse alloc] initWithDocument:document];
        if (!response) {
            error = [NSError errorWithDomain:@"WAResponse"
                                        code:1
                                     message:@"Invalid response XML"];
            [self delegateInformError:error];
            return;
        }
        [self delegateInformResult:response];
    }
}

@end
