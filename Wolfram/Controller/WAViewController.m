//
//  WAViewController.m
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewController.h"

@implementation WAViewController

@synthesize view;
@synthesize model;

- (id)initWithView:(WAView *)aView model:(WAModel *)aModel {
    if ((self = [super init])) {
        view = aView;
        model = aModel;
    }
    return self;
}

@end
