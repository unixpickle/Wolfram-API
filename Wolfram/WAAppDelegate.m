//
//  WAAppDelegate.m
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAppDelegate.h"
#import "WAResponse.h"

@implementation WAAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    //model = [[WAModel alloc] init];
    //[model setDelegate:self];
    //[model searchQuery:@"James"];
    
    mainView = [[WAView alloc] initWithFrame:[self.window.contentView bounds]];
    [self.window.contentView addSubview:mainView];
}

- (void)model:(WAModel *)model gotResponse:(WAResponse *)response {
    NSLog(@"Response: %lu pods and %lu assumptions",
          [[response pods] count],
          [[response assumptions] count]);
}

- (void)model:(WAModel *)aModel gotPod:(WAPod *)pod {
    NSLog(@"Got pod: %@ (%@)", [pod title], [pod identifier]);
}

- (void)model:(WAModel *)model failedToLoad:(NSError *)error {
    NSLog(@"Model error: %@", error);
}

- (void)modelFinishedAllQueries:(WAModel *)model {
    NSLog(@"Done queries");
}

@end
