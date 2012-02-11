//
//  WAImage.m
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAImage.h"

@implementation WAImage

@synthesize size;
@synthesize imageURL;

- (id)initWithElement:(WAXMLNode *)node {
    if ((self = [super init])) {
        NSString * widthStr = [node valueForAttribute:@"width"];
        NSString * heightStr = [node valueForAttribute:@"height"];
        NSString * urlStr = [node valueForAttribute:@"src"];
        if (!widthStr || !heightStr || !urlStr) return nil;
        size = CGSizeMake([widthStr floatValue], [heightStr floatValue]);
        imageURL = [NSURL URLWithString:urlStr];
    }
    return self;
}

@end
