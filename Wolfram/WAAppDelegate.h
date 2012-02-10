//
//  WAAppDelegate.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAViewController.h"

@interface WAAppDelegate : NSObject <NSApplicationDelegate> {
    WAModel * model;
    WAView * view;
    WAViewController * controller;
}

@property (assign) IBOutlet NSWindow * window;

@end
