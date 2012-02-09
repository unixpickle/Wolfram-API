//
//  WAViewSearchItem.m
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewSearchItem.h"

@implementation WAViewSearchItem

- (id)initWithFrame:(NSRect)frame title:(NSString *)aTitle {
    if ((self = [super initWithFrame:frame title:aTitle])) {
        searchField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, frame.size.width - 20, 24)];
        [searchField setBezeled:YES];
        [searchField setBezelStyle:NSTextFieldRoundedBezel];
        [[searchField cell] setPlaceholderString:@"Search Query"];
        [self addSubview:searchField];
    }
    return self;
}

+ (CGFloat)contentHeight {
    return 40;
}

- (void)handleCollapseExpand:(BOOL)expanded {
    if (expanded) {
        if (![searchField superview]) [self addSubview:searchField];
    } else {
        if ([searchField superview]) [searchField removeFromSuperview];
    }
}

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    [searchField setFrame:NSMakeRect(10, 10, frame.size.width - 20, 24)];
}

@end
