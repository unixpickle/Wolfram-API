//
//  WAAssumption.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAAssumptionValue.h"

#define kAssumptionTypeFormulaSolve @"FormulaSolve"
#define kAssumptionTypeFormulaVariable @"FormulaVariable"
#define kAssumptionTypeFormulaVariableOption @"FormulaVariableOption"
#define kAssumptionTypeFormulaVariableInclude @"FormulaVariableInclude"
#define kAssumptionTypeFormulaSelect @"FormulaSelect"
#define kAssumptionTypeClash @"Clash"

typedef enum {
    WAAssumptionInputTypeVariableCustom,
    WAAssumptionInputTypeVariableList,
    WAAssumptionInputTypeInclude,
    WAAssumptionInputTypeList
} WAAssumptionInputType;

@interface WAAssumption : NSObject {
    NSArray * values;
    NSString * type;
    NSString * description;
    NSNumber * current;
    NSString * word;
}

@property (readonly) NSArray * values;
@property (readonly) NSString * type;
@property (readonly) NSString * description;
@property (readonly) NSNumber * current;
@property (readonly) NSString * word;

- (id)initWithValues:(NSArray *)someValues attributes:(NSDictionary *)someAttributes;
- (id)initWithElement:(WAXMLNode *)node;

- (WAAssumptionInputType)inputType;
- (NSString *)promptLabel;
- (NSString *)inputValue;

@end
