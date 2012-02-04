//
//  WAXMLNode.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAXMLNode.h"

@implementation WAXMLNode

@synthesize elements;
@synthesize nodeName;

- (id)initWithNodeName:(NSString *)name attributes:(NSDictionary *)attributes {
    if ((self = [super init])) {
        nodeName = name;
        elements = [[NSMutableArray alloc] init];
        _attributes = [[NSMutableDictionary alloc] init];
        for (NSString * attribute in attributes) {
            [self setValue:[attributes objectForKey:attribute] forAttribute:attribute];
        }
    }
    return self;
}

- (NSString *)valueForAttribute:(NSString *)attribute {
    return [_attributes objectForKey:[attribute lowercaseString]];
}

- (void)setValue:(NSString *)value forAttribute:(NSString *)attribute {
    [_attributes setObject:value forKey:[attribute lowercaseString]];
}

@end
