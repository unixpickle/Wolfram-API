//
//  WAResponse.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAAssumption.h"
#import "WAPod.h"

@interface WAResponse : NSObject {
    NSArray * pods;
    NSArray * assumptions;
    BOOL success;
    BOOL parseTimedOut;
}

@property (readonly) NSArray * pods;
@property (readonly) NSArray * assumptions;
@property (readonly) BOOL success;
@property (readonly) BOOL parseTimedOut;

- (id)initWithDocument:(WAXMLDocument *)document;

@end
