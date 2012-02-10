//
//  WAAppDelegate.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAController.h"

@interface WAAppDelegate : NSObject <NSApplicationDelegate> {
    WAModel * model;
    WAView * view;
    WAController * controller;
}

@property (assign) IBOutlet NSWindow * window;

@end
