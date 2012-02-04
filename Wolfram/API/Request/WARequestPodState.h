//
//  WARequestPodState.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+URLCode.h"

@interface WARequestPodState : NSObject {
    NSString * podName;
    NSString * subPodName;
    NSString * state;
}

@property (readonly) NSString * podName;
@property (readonly) NSString * subPodName;
@property (readonly) NSString * state;

- (id)initWithPod:(NSString *)pod subPod:(NSString *)subPod state:(NSString *)aState;
- (id)initWithPod:(NSString *)pod state:(NSString *)aState;
+ (id)requestPodWithPod:(NSString *)pod subPod:(NSString *)subPod state:(NSString *)aState;
+ (id)requestPodWithPod:(NSString *)pod state:(NSString *)aState;
- (NSString *)encodedString;

@end
