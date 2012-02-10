//
//  WAEventManager.h
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAEvent.h"

@class WAEventManager;

@protocol WAEventManagerTarget

- (void)eventManager:(WAEventManager *)manager receivedEvent:(WAEvent *)event;

@end

@interface WAEventManager : NSObject {
    __weak id<WAEventManagerTarget> target;
}

@property (readonly) id<WAEventManagerTarget> target;

- (id)initWithTarget:(id<WAEventManagerTarget>)aTarget;
- (void)postEvent:(WAEvent *)event;

@end
