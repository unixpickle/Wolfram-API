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
        [view setDelegate:self];
        [model setDelegate:self];
    }
    return self;
}

#pragma mark - View -

- (void)waView:(WAView *)view item:(WAViewItem *)item event:(WAViewEvent *)event {
    // handle event
    NSLog(@"Controller got event");
}

#pragma mark - Model -

- (void)model:(WAModel *)model gotPod:(WAPod *)pod {
    
}

- (void)model:(WAModel *)model gotAssumptions:(NSArray *)assumptions {
    
}

- (void)model:(WAModel *)model failedToLoad:(NSError *)error {
    
}

- (void)model:(WAModel *)model gotResponse:(WAResponse *)response {
    
}

- (void)modelFinishedAllQueries:(WAModel *)model {
    
}

@end
