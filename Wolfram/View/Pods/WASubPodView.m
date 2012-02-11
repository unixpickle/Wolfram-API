//
//  WASubpodView.m
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WASubPodView.h"

@implementation WASubPodView

@synthesize subPod;

- (id)initWithFrame:(NSRect)frameRect subPod:(WASubPod *)aSubPod {
    if ((self = [super initWithFrame:frameRect])) {
        subPod = aSubPod;
        if ([subPod imageRepresentation]) {
            WAImageView * imageView = [[WAImageView alloc] initWithWidth:frameRect.size.width - 20
                                                                   image:[subPod imageRepresentation]];
            dataView = imageView;
        }
        if (dataView) {
            frameRect.size.height = dataView.frame.size.height;
            [self addSubview:dataView];
        } else {
            frameRect.size.height = 10;
        }
        [self setFrame:frameRect];
    }
    return self;
}

- (void)resizeToWidth:(CGFloat)width {
    if (dataView) {
        [dataView resizeToWidth:width];
        NSRect frame = self.frame;
        frame.size.width = width;
        frame.size.height = dataView.frame.size.height;
        self.frame = frame;
    } else {
        NSRect frame = self.frame;
        frame.size.width = width;
        self.frame = frame;
    }
}

@end
