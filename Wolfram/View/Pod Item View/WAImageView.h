//
//  WAImageView.h
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAImage.h"
#import "WADataView.h"

@interface WAImageView : NSView <WADataView> {
    WAImage * image;
    
    NSImage * displayImage;
    __strong NSImageView * imageView;
    NSThread * fetchThread;
    
}

@property (readonly) WAImage * image;

- (id)initWithWidth:(CGFloat)width image:(WAImage *)anImage;

@end
