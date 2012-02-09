//
//  WAViewEvent.h
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WAViewEventTypeSearch,
    WAViewEventTypeResize
} WAViewEventType;

@interface WAViewEvent : NSObject {
    WAViewEventType eventType;
    NSDictionary * userInfo;
}

@property (readonly) WAViewEventType eventType;
@property (readonly) NSDictionary * userInfo;

- (id)initWithEventType:(WAViewEventType)type userInfo:(NSDictionary *)info;

@end
