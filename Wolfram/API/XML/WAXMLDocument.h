//
//  WAXMLDocument.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAXMLNode.h"
#import "WAXMLText.h"

@interface WAXMLDocument : NSObject <NSXMLParserDelegate> {
    WAXMLNode * rootNode;
    WAXMLNode * currentNode;
}

@property (readonly) WAXMLNode * rootNode;

- (id)initWithXMLData:(NSData *)theData;

@end
