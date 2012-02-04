//
//  WAXMLText.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAXMLText.h"

@implementation WAXMLText

@synthesize text;

- (id)initWithText:(NSString *)theText {
    if ((self = [super init])) {
        text = theText;
    }
    return self;
}

@end
