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
    NSString * path = @"/Users/alex/Desktop/query.xml";
    NSData * xmlData = [NSData dataWithContentsOfFile:path];
    WAXMLDocument * document = [[WAXMLDocument alloc] initWithXMLData:xmlData];
    __unused WAResponse * response = [[WAResponse alloc] initWithDocument:document];
}

@end
