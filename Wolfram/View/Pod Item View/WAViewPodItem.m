//
//  WAViewPodItem.m
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewPodItem.h"

@interface WAViewPodItem (Private)

- (void)layoutSubPods;

@end

@implementation WAViewPodItem

@synthesize pod;

- (id)initWithFrame:(NSRect)frame pod:(WAPod *)thePod {
    if ((self = [super initWithFrame:frame title:[thePod title]])) {
        pod = thePod;
        if ([thePod asyncURL] && [[thePod subPods] count] == 0) {
            [self setLoading:YES];
        }
        
        NSMutableArray * mSubPods = [[NSMutableArray alloc] initWithCapacity:[[thePod subPods] count]];
        CGFloat subpodWidth = frame.size.width - 20;
        CGFloat subpodHeight = 10;
        for (WASubPod * subPod in [thePod subPods]) {
            WASubPodView * subPodView = [[WASubPodView alloc] initWithFrame:NSMakeRect(0, 0, subpodWidth, 0)
                                                                     subPod:subPod];
            [mSubPods addObject:subPodView];
            subpodHeight += subPodView.frame.size.height + 10;
        }
        
        subPodViews = [[NSArray alloc] initWithArray:mSubPods];
        
        calculatedHeight = subpodHeight;
        [self fitBoundsToHeight];
        [self layoutSubPods];
    }
    return self;
}

- (CGFloat)contentHeight {
    return calculatedHeight;
}

- (void)layoutForWidth {
    if (![self isExpanded]) return;
    CGFloat width = self.frame.size.width;
    CGFloat subpodWidth = width - 20;
    CGFloat subpodHeight = 10;
    for (WASubPodView * subPod in subPodViews) {
        [subPod resizeToWidth:subpodWidth];
        subpodHeight += subPod.frame.size.height + 10;
    }
    
    if (calculatedHeight != subpodHeight) {
        calculatedHeight = subpodHeight;
        [self fitBoundsToHeight];
    }
    
    [self layoutSubPods];
}

- (void)layoutSubPods {
    CGFloat y = 10;
    for (NSInteger i = [subPodViews count] - 1; i >= 0; i--) {
        WASubPodView * subPodView = [subPodViews objectAtIndex:i];
        NSRect frame = subPodView.frame;
        frame.origin.y = y;
        frame.origin.x = 10;
        y += frame.size.height + 10;
        
        subPodView.frame = frame;
        if (![subPodView superview]) {
            [self addSubview:subPodView];
        }
    }
}

- (void)layoutExpanded {
    [super layoutExpanded];
    [self layoutForWidth];
}

- (void)layoutCollapsed {
    [super layoutCollapsed];
    for (WASubPodView * spv in subPodViews) {
        [spv removeFromSuperview];
    }
}

@end
