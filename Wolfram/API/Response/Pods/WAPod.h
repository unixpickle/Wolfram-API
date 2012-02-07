//
//  WAPod.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WASubPod.h"
#import "WAPodStateList.h"

@interface WAPod : NSObject {
    NSString * title;
    NSString * scanner;
    NSString * identifier;
    NSString * error;
    NSArray * subPods;
    NSArray * podStates;
    NSURL * asyncURL;
}

@property (readonly) NSString * title;
@property (readonly) NSString * scanner;
@property (readonly) NSString * identifier;
@property (readonly) NSString * error;
@property (readonly) NSArray * subPods;
@property (readonly) NSArray * podStates;
@property (readonly) NSURL * asyncURL;

- (id)initWithElement:(WAXMLNode *)node;

@end
