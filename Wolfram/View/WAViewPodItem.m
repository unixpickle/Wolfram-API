//
//  WAViewPodItem.m
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewPodItem.h"

@implementation WAViewPodItem

@synthesize pod;

- (id)initWithFrame:(NSRect)frame pod:(WAPod *)thePod {
    if ((self = [super initWithFrame:frame title:[thePod title]])) {
        pod = thePod;
        if ([thePod asyncURL] && [[thePod subPods] count] == 0) {
            [self setLoading:YES];
        }
        // TODO: calculate the view height based on the subpod heights, etc.
        // [self fitBoundsToHeight]
    }
    return self;
}

- (CGFloat)contentHeight {
    return 100;
}

@end
