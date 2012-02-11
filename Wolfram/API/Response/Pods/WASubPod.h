//
//  WASubPod.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAPlainText.h"
#import "WAImage.h"
#import "WAXMLDocument.h"
#import "WAPodState.h"

@class WAPod;

@interface WASubPod : NSObject {
    NSString * title;
    NSArray * representations;
    NSArray * podStates;
    __weak WAPod * pod;
}

@property (readonly) NSString * title;
@property (readonly) NSArray * representations;
@property (readonly) NSArray * podStates;
@property (readonly) WAPod * pod;

- (id)initWithElement:(WAXMLNode *)node pod:(WAPod *)parentPod;
- (id)representationOfClass:(Class)aClass;
- (WAImage *)imageRepresentation;

@end
