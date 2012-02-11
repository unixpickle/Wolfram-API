//
//  WAPodCell.h
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewItemCell.h"
#import "WAPod.h"
#import "WASubPodView.h"

@interface WAPodCell : WAViewItemCell {
    WAPod * pod;
    NSArray * subPodViews;
    CGFloat totalHeight;
}

@property (readonly) WAPod * pod;

- (id)initWithEventManager:(WAEventManager *)manager pod:(WAPod *)thePod;

@end
