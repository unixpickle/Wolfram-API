//
//  WAPlainText.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAPlainText.h"

@implementation WAPlainText

@synthesize text;

- (id)initWithText:(NSString *)plainText {
    if ((self = [super init])) {
        text = plainText;
    }
    return self;
}

@end
