//
//  WAEvent.h
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WAEventTypeAssumption,
    WAEventTypeStateChange,
    WAEventTypeSearch,
    WAEventTypeExpandCollapse
} WAEventType;

#define kWAEventQueryUserInfoKey @"kWAEventQueryUserInfoKey"
#define kWAEventDeltaHeightUserInfoKey @"kWAEventDeltaHeightUserInfoKey"
#define kWAEventAssumptionValueUserInfoKey @"kWAEventAssumptionValueUserInfoKey"

@interface WAEvent : NSObject {
    WAEventType _eventType;
    NSDictionary * _userInfo;
    __weak id _sender;
}

@property (readonly) WAEventType eventType;
@property (readonly) NSDictionary * userInfo;
@property (readonly) __weak id sender;

- (id)initWithEventType:(WAEventType)eventType sender:(id)sender userInfo:(NSDictionary *)userInfo;
- (id)initWithEventType:(WAEventType)eventType sender:(id)sender object:(id)obj forKey:(NSString *)key;
+ (WAEvent *)eventWithType:(WAEventType)eventType sender:(id)sender userInfo:(NSDictionary *)userInfo;
+ (WAEvent *)eventWithType:(WAEventType)eventType sender:(id)sender object:(id)obj forKey:(NSString *)key;
+ (WAEvent *)eventWithType:(WAEventType)eventType sender:(id)sender;

@end
