//
//  WAPodState.h
//  Wolfram
//
//  Created by Nichol, Alexander on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAXMLDocument.h"
#import "NSString+URLCode.h"

@class WAPodStateList;
@class WAPod;

@interface WAPodState : NSObject {
    __weak WAPod * pod;
    __weak WAPodStateList * parentList;
    NSString * name;
    NSString * input;
}

@property (readonly) WAPod * pod;
@property (readonly) WAPodStateList * parentList;
@property (readonly) NSString * name;
@property (readonly) NSString * input;

- (id)initWithName:(NSString *)aName
             input:(NSString *)theInput 
              list:(WAPodStateList *)parent
               pod:(WAPod *)parentPod;
- (id)initWithElement:(WAXMLNode *)node
                 list:(WAPodStateList *)parent
                  pod:(WAPod *)parentPod;

- (NSString *)encodeInput;
+ (NSArray *)podStatesFromElement:(WAXMLNode *)element pod:(WAPod *)parentPod;


@end
