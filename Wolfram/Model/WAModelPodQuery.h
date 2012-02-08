//
//  WAModelPodQuery.h
//  Wolfram
//
//  Created by Alex Nichol on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAModelRequest.h"
#import "WAResponse.h"

@interface WAModelPodQuery : WAModelRequest {
    NSURL * podURL;
}

- (id)initWithURL:(NSURL *)aPodURL;

@end
