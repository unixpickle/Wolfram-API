//
//  WASubpodView.h
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WASubPod.h"
#import "WAImageView.h"

@interface WASubPodView : NSView {
    WASubPod * subPod;
    __strong NSView<WADataView> * dataView;
}

@property (readonly) WASubPod * subPod;

- (id)initWithFrame:(NSRect)frameRect subPod:(WASubPod *)aSubPod;
- (void)resizeToWidth:(CGFloat)width;

@end
