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

@interface WAPodState : NSObject {
    WAPodStateList * parentList;
    NSString * name;
    NSString * input;
}

@property (readonly) WAPodStateList * parentList;
@property (readonly) NSString * name;
@property (readonly) NSString * input;

+ (NSArray *)podStatesFromElement:(WAXMLNode *)element;
- (id)initWithName:(NSString *)aName input:(NSString *)theInput list:(WAPodStateList *)parent;
- (id)initWithElement:(WAXMLNode *)node list:(WAPodStateList *)parent;
- (NSString *)encodeInput;

@end