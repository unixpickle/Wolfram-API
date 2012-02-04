//
//  WAXMLDocument.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAXMLDocument.h"

@implementation WAXMLDocument

@synthesize rootNode;

- (id)initWithXMLData:(NSData *)theData {
    if ((self = [super init])) {
        rootNode = [[WAXMLNode alloc] initWithNodeName:@"" attributes:nil];
        currentNode = rootNode;
        NSXMLParser * parser = [[NSXMLParser alloc] initWithData:theData];
        [parser setDelegate:self];
        if (![parser parse]) {
            return nil;
        }
        currentNode = nil;
    }
    return self;
}

#pragma mark - XML Parser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    WAXMLNode * node = [[WAXMLNode alloc] initWithNodeName:elementName attributes:attributeDict];
    node.parentElement = currentNode;
    [[currentNode elements] addObject:node];
    currentNode = node;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:[currentNode nodeName]] && currentNode != rootNode) {
        currentNode = currentNode.parentElement;
    } else {
        currentNode = rootNode;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    WAXMLText * text = [[WAXMLText alloc] init];
    text.text = string;
    text.parentElement = currentNode;
    [[currentNode elements] addObject:text];
}

@end
