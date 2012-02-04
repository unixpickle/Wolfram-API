//
//  WAAssumption.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAAssumptionValue.h"

typedef enum {
    WAAssumptionInputTypeCustom,
    WAAssumptionInputTypeList,
    WAAssumptionInputTypeLink
} WAAssumptionInputType;

@interface WAAssumption : NSObject {
    NSArray * values;
    NSString * type;
    NSString * description;
    NSNumber * current;
    NSNumber * count;
    NSString * word;
}

@property (readonly) NSArray * values;
@property (readonly) NSString * type;
@property (readonly) NSString * description;
@property (readonly) NSNumber * current;
@property (readonly) NSNumber * count;
@property (readonly) NSString * word;

- (id)initWithValues:(NSArray *)someValues attributes:(NSDictionary *)someAttributes;
- (id)initWithElement:(WAXMLNode *)node;

- (WAAssumptionInputType)inputType;

@end
