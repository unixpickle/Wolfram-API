//
//  WARequestAssumption.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+URLCode.h"

@interface WARequestAssumption : NSObject {
    NSString * assumptionName;
    NSString * assumptionValue;
}

@property (readonly) NSString * assumptionName;
@property (readonly) NSString * assumptionValue;

- (id)initWithName:(NSString *)name value:(NSString *)value;
- (id)initWithAssumptionString:(NSString *)string;
+ (id)requestAssumptionWithName:(NSString *)name value:(NSString *)value;
- (NSString *)encodedString;

@end
