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

#pragma mark Events

- (void)waView:(WAView *)view item:(WAViewItem *)item event:(WAViewEvent *)event {
    NSLog(@"Controller got event");
    if ([event eventType] == WAViewEventTypeSearch) {
        [self handleSearchEvent:event];
    }
}

- (void)handleSearchEvent:(WAViewEvent *)event {
    NSString * query = [[event userInfo] objectForKey:WAViewEventQueryKey];
    [model searchQuery:query];
    [view removeItems];
    [[view searchItem] setLoading:YES];
}

#pragma mark - Model -

- (void)model:(WAModel *)model gotPod:(WAPod *)pod {
    NSLog(@"Got pod: %@", [pod title]);
}

- (void)model:(WAModel *)model gotAssumptions:(NSArray *)assumptions {
    NSLog(@"Assumptions (count): %lu", [assumptions count]);
}

- (void)model:(WAModel *)model failedToLoad:(NSError *)error {
    NSLog(@"Load failed: %@", error);
}

- (void)model:(WAModel *)model gotResponse:(WAResponse *)response {
    NSLog(@"Received response: (%lu assumptions, %lu pods)", [[response assumptions] count], [[response pods] count]);
}

- (void)modelFinishedAllQueries:(WAModel *)model {
    [[view searchItem] setLoading:NO];
}

@end
