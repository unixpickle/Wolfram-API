//
//  WAViewPodItem.h
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewItem.h"
#import "WAPod.h"
#import "WASubPodView.h"

@interface WAViewPodItem : WAViewItem {
    WAPod * pod;
    NSArray * subPodViews;
    CGFloat calculatedHeight;
}

@property (readonly) WAPod * pod;

- (id)initWithFrame:(NSRect)frame pod:(WAPod *)thePod;

@end
