//
//  WAModelQuery.h
//  Wolfram
//
//  Created by Alex Nichol on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAModelRequest.h"
#import "WARequest.h"
#import "WAResponse.h"

#define kUseAsync YES

@interface WAModelQuery : WAModelRequest {
    WARequest * request;
    NSString * podID;
}

@property (readonly) NSString * podID;

- (id)initWithRequest:(WARequest *)aRequest podID:(NSString *)aPodID;

@end
