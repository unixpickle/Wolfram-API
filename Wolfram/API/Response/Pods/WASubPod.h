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
#import "WAPodState.h"

@interface WASubPod : NSObject {
    NSString * title;
    NSArray * representations;
    NSArray * podStates;
}

@property (readonly) NSString * title;
@property (readonly) NSArray * representations;
@property (readonly) NSArray * podStates;

- (id)initWithElement:(WAXMLNode *)node;

@end
