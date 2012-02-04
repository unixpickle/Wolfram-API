//
//  WAAssumptionValue.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAXMLDocument.h"
#import "NSString+URLCode.h"

@interface WAAssumptionValue : NSObject {
    NSString * name;
    NSString * description;
    NSString * input;
    NSNumber * valid;
}

@property (readonly) NSString * name;
@property (readonly) NSString * description;
@property (readonly) NSString * input;
@property (readonly) NSNumber * valid;

- (id)initWithName:(NSString *)aName
       description:(NSString *)aDescription
             input:(NSString *)theInput
             valid:(NSNumber *)aValid;

- (id)initWithNode:(WAXMLNode *)node;

- (NSString *)assumptionValueWithDescription:(NSString *)newValue;

@end
