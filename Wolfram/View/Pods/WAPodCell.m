//
//  WAViewPodItem.m
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAPodCell.h"

@interface WAPodCell (Private)

- (void)layoutSubPods;

@end

@implementation WAPodCell

@synthesize pod;

- (id)initWithEventManager:(WAEventManager *)manager pod:(WAPod *)thePod {
    if ((self = [super initWithEventManager:manager title:[thePod title]])) {
        NSRect frame = self.frame;
        
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
        
        [self layoutSubPods];
    }
    return self;
}

- (void)resizeToWidth:(CGFloat)width {
    CGFloat subpodWidth = width - 20;
    CGFloat subpodHeight = 10;
    for (WASubPodView * subPod in subPodViews) {
        [subPod resizeToWidth:subpodWidth];
        subpodHeight += subPod.frame.size.height + 10;
    }
    
    NSRect frame = self.frame;
    frame.size.height = subpodHeight;
    frame.size.width = width;
    self.frame = frame;
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

- (void)drawRect:(NSRect)dirtyRect {
    if ([subPodViews count] < 2) return;
    const CGFloat dashLengths[2] = {1.0, 1.0}; 
    
    // draw pod separators
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 1);
    CGContextSetLineWidth(context, 1);
    CGContextSetLineDash(context, 0, dashLengths, 1);
    for (NSUInteger i = 0; i < [subPodViews count] - 1; i++) {
        WASubPodView * podView = [subPodViews objectAtIndex:i];
        if ([podView superview]) {
            CGFloat lineY = podView.frame.origin.y - 5;
            CGPoint points[2] = {CGPointMake(10, lineY - 0.5),
                                 CGPointMake(self.frame.size.width - 10, lineY + 0.5)};
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, points[0].x, points[0].y);
            CGContextAddLineToPoint(context, points[1].x, points[1].y);
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
}

@end
