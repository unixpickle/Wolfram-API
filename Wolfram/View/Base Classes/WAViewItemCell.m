//
//  WAViewItemCell.m
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewItemCell.h"

@implementation WAViewItemCell

@synthesize eventManager;
@synthesize title;
@synthesize loading;

- (id)initWithEventManager:(WAEventManager *)manager title:(NSString *)aTitle {
    if ((self = [super initWithFrame:NSMakeRect(0, 0, 200, 10)])) {
        eventManager = manager;
        title = aTitle;
    }
    return self;
}

- (void)resizeToWidth:(CGFloat)width {
    NSRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

@end
