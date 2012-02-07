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

@class WAAssumption;

@interface WAAssumptionValue : NSObject {
    NSString * name;
    NSString * description;
    NSString * input;
    NSNumber * valid;
    WAAssumption * assumption;
}

@property (readonly) NSString * name;
@property (readonly) NSString * description;
@property (readonly) NSString * input;
@property (readonly) NSNumber * valid;
@property (readonly) WAAssumption * assumption;

- (id)initWithName:(NSString *)aName
       description:(NSString *)aDescription
             input:(NSString *)theInput
             valid:(NSNumber *)aValid
        assumption:(WAAssumption *)parent;

- (id)initWithNode:(WAXMLNode *)node assumption:(WAAssumption *)parent;

/**
 * Replaces the string after the "_" character.
 */
- (WAAssumptionValue *)valueWithInputValue:(NSString *)customValue;

@end
