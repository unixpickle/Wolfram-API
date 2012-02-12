//
//  WARequestAssumption.h
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAAssumption.h"

@interface WARequestAssumption : NSObject {
    NSString * name;
    NSString * input;
    NSString * type;
    NSString * word;
    NSString * desc;
    WAAssumptionInputType inputType;
}

@property (readonly) NSString * name;
@property (readonly) NSString * input;

- (id)initWithName:(NSString *)theName
             input:(NSString *)theInput;
- (id)initWithAssumptionValue:(WAAssumptionValue *)value;

- (NSString *)inputPrefix;
- (BOOL)conflictsWithAssumption:(WARequestAssumption *)anAssumption;

@end
