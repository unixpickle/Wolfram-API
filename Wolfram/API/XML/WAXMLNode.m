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

- (NSArray *)elementsWithName:(NSString *)name {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (WAXMLElement * element in elements) {
        if ([element isKindOfClass:[WAXMLNode class]]) {
            WAXMLNode * node = (WAXMLNode *)element;
            if ([[node nodeName] isEqualToString:name]) {
                [array addObject:node];
            }
        }
    }
    return [NSArray arrayWithArray:array];
}

- (WAXMLNode *)elementWithName:(NSString *)name {
    NSArray * theElements = [self elementsWithName:name];
    if ([theElements count] > 0) {
        return [theElements objectAtIndex:0];
    }
    return nil;
}

@end
