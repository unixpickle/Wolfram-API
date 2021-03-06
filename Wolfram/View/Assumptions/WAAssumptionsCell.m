//
//  WAAssumptionsCell.m
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAAssumptionsCell.h"

@interface WAAssumptionsCell (Private)

- (void)layoutAssumptionViews;

@end

@implementation WAAssumptionsCell

- (id)initWithEventManager:(WAEventManager *)manager assumptions:(NSArray *)assumptions {
    if ((self = [super initWithEventManager:manager title:@"Assumptions"])) {
        NSMutableArray * mAssumpViews = [[NSMutableArray alloc] initWithCapacity:[assumptions count]];
        for (WAAssumption * assumption in assumptions) {
            WAAssumptionView * assumptionView = nil;
            Class viewClass = Nil;
            
            if ([assumption inputType] == WAAssumptionInputTypeVariableCustom) {
                viewClass = [WAAssumpViewInput class];
            } else if ([assumption inputType] == WAAssumptionInputTypeInclude) {
                viewClass = [WAAssumpViewInclude class];
            } else {
                viewClass = [WAAssumpViewPicker class];
            }
            
            if (viewClass != Nil) {
                assumptionView = [[viewClass alloc] initWithEventManager:manager
                                                              assumption:assumption];
                [mAssumpViews addObject:assumptionView];
            }
        }
        assumptionViews = [[NSArray alloc] initWithArray:mAssumpViews];
        [self layoutAssumptionViews];
    }
    return self;
}

- (void)resizeToWidth:(CGFloat)width {
    CGFloat subviewWidth = width - 20;
    CGFloat height = 10;
    for (WAAssumptionView * assumpView in assumptionViews) {
        [assumpView resizeToWidth:subviewWidth];
        height += assumpView.frame.size.height + 10;
    }
    NSRect frame = self.frame;
    frame.size.height = height;
    frame.size.width = width;
    self.frame = frame;
    [self layoutAssumptionViews];
}

- (void)layoutAssumptionViews {
    CGFloat y = 10;
    for (NSInteger i = [assumptionViews count] - 1; i >= 0; i--) {
        WAAssumptionView * assumpView = [assumptionViews objectAtIndex:i];
        NSRect frame = assumpView.frame;
        frame.origin.y = y;
        frame.origin.x = 10;
        assumpView.frame = frame;
        y += frame.size.height + 10;
        if (![assumpView superview]) {
            [self addSubview:assumpView];
        }
    }
}

@end
