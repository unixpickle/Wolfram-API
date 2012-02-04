//
//  WAXMLNode.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAXMLElement.h"

@interface WAXMLNode : WAXMLElement {
    NSMutableArray * elements;
    NSString * nodeName;
    NSMutableDictionary * _attributes;
}

@property (readonly) NSMutableArray * elements;
@property (nonatomic, retain) NSString * nodeName;

- (id)initWithNodeName:(NSString *)name attributes:(NSDictionary *)attributes;

- (NSString *)valueForAttribute:(NSString *)attribute;
- (void)setValue:(NSString *)value forAttribute:(NSString *)attribute;

@end
