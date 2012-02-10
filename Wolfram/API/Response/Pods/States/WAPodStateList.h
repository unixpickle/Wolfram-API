//
//  WAPodStateList.h
//  Wolfram
//
//  Created by Nichol, Alexander on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAPodState.h"

@interface WAPodStateList : NSObject {
    NSArray * podStates;
}

@property (readonly) NSArray * podStates;

- (id)initWithStates:(NSArray *)states;
- (id)initWithElement:(WAXMLNode *)node pod:(WAPod *)aPod;

@end
