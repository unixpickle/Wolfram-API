//
//  WASubPod.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAPlainText.h"
#import "WAXMLDocument.h"

@interface WASubPod : NSObject {
    NSString * title;
    NSArray * representations;
}

@property (readonly) NSString * title;
@property (readonly) NSArray * representations;

- (id)initWithElement:(WAXMLNode *)node;

@end
