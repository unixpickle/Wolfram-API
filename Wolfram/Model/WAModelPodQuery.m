//
//  WAModelPodQuery.m
//  Wolfram
//
//  Created by Alex Nichol on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAModelPodQuery.h"

@implementation WAModelPodQuery

- (id)initWithURL:(NSURL *)aPodURL {
    if ((self = [super init])) {
        podURL = aPodURL;
    }
    return self;
}

- (void)backgroundMethod {
    @autoreleasepool {
        [NSThread sleepForTimeInterval:5];
        NSError * error = nil;
        WAXMLDocument * document = [[self class] fetchXMLDocument:podURL error:&error];
        if ([[NSThread currentThread] isCancelled]) return;
        if (!document) {
            [self delegateInformError:error];
            return;
        }
        
        // process the XML as a response
        WAXMLNode * podElement = [[document rootNode] elementWithName:@"pod"];
        WAPod * pod = [[WAPod alloc] initWithElement:podElement];
        if (!pod || !podElement) {
            error = [NSError errorWithDomain:@"WAResponse"
                                        code:1
                                     message:@"Invalid response XML"];
            [self delegateInformError:error];
            return;
        }
        [self delegateInformResult:pod];
    }
}

@end
