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
    model = [[WAModel alloc] init];
    view = [[WAView alloc] initWithFrame:[self.window.contentView bounds]];
    [view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    
    [self.window.contentView addSubview:view];
    [view hookupWindowNotifications];
    
    controller = [[WAController alloc] initWithView:view model:model];
    [self.window makeFirstResponder:[[view searchCell] searchField]];
}

@end
