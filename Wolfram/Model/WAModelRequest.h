//
//  WAModelRequest.h
//  Wolfram
//
//  Created by Alex Nichol on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAXMLDocument.h"
#import "NSError+Message.h"

@protocol WAModelRequestDelegate <NSObject>

@optional
- (void)modelRequest:(id)sender failedWithError:(NSError *)anError;
- (void)modelRequest:(id)sender fetchedObject:(id)object;

@end

@interface WAModelRequest : NSObject {
    NSThread * backgroundThread;
}

@property (nonatomic, weak) id<WAModelRequestDelegate> delegate;
- (void)start;
- (void)cancel;

- (void)backgroundThread;
+ (WAXMLDocument *)fetchXMLDocument:(NSURL *)aURL error:(NSError **)error;

- (void)delegateInformError:(NSError *)error;
- (void)delegateInformResult:(id)object;

@end
