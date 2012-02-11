//
//  WAImageView.m
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAImageView.h"

@interface WAImageView (Scaling)

- (CGFloat)heightForWidth:(CGFloat)viewWidth;

@end

@interface WAImageView (Threading)

- (void)fetchThread:(NSURL *)imageURL;
- (void)handleImageData:(NSData *)theData;

@end

@implementation WAImageView

@synthesize image;

- (id)initWithWidth:(CGFloat)width image:(WAImage *)anImage {
    if ((self = [super initWithFrame:NSZeroRect])) {
        image = anImage;
        NSRect frame = NSMakeRect(0, 0, width, [self heightForWidth:width]);
        self.frame = frame;
        
        imageView = [[NSImageView alloc] initWithFrame:frame];
        [self addSubview:imageView];
        
        fetchThread = [[NSThread alloc] initWithTarget:self
                                              selector:@selector(fetchThread:)
                                                object:[anImage imageURL]];
        [fetchThread start];
    }
    return self;
}

- (void)resizeToWidth:(CGFloat)newWidth {
    CGFloat height = [self heightForWidth:newWidth];
    [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, newWidth, height)];
    [imageView setFrame:NSMakeRect(0, 0, newWidth, height)];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [fetchThread cancel];
    fetchThread = nil;
}

#pragma mark - Private -

#pragma mark Scaling

- (CGFloat)heightForWidth:(CGFloat)viewWidth {
    if (viewWidth >= image.size.width) return image.size.height;
    CGFloat scale = image.size.width / viewWidth;
    return ceil(image.size.height / scale);
}

#pragma mark Background

- (void)fetchThread:(NSURL *)imageURL {
    @autoreleasepool {
        NSURLRequest * request = [NSURLRequest requestWithURL:imageURL];
        NSData * imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (![[NSThread currentThread] isCancelled]) {
            [self performSelectorOnMainThread:@selector(handleImageData:)
                                   withObject:imageData waitUntilDone:NO];
        }
    }
}

- (void)handleImageData:(NSData *)theData {
    fetchThread = nil;
    displayImage = [[NSImage alloc] initWithData:theData];
    [imageView setImage:displayImage];
}

@end
