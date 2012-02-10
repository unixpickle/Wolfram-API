//
//  WAViewSearchItem.m
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewSearchItem.h"

@interface WAViewSearchItem (Private)

- (void)deselectSearchText;

@end

@implementation WAViewSearchItem

+ (CGFloat)contentHeight {
    return 40;
}

- (id)initWithFrame:(NSRect)frame title:(NSString *)aTitle {
    if ((self = [super initWithFrame:frame title:aTitle])) {
        searchField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, frame.size.width - 20, 22)];
        [searchField setBezeled:YES];
        [searchField setBezelStyle:NSTextFieldSquareBezel];
        [searchField setTarget:self];
        [searchField setAction:@selector(searchEnter:)];
        [[searchField cell] setPlaceholderString:@"Search Query"];
        [self addSubview:searchField];
    }
    return self;
}

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    [searchField setFrame:NSMakeRect(10, 10, frame.size.width - 20, 22)];
}

- (void)expand {
    [super expand];
    if (![searchField superview]) [self addSubview:searchField];
}

- (void)collapse {
    [super collapse];
    if ([searchField superview]) [searchField removeFromSuperview];
}

- (void)searchEnter:(id)sender {
    NSDictionary * info = [NSDictionary dictionaryWithObject:[searchField stringValue]
                                                      forKey:WAViewEventQueryKey];
    WAViewEvent * event = [[WAViewEvent alloc] initWithEventType:WAViewEventTypeSearch
                                                        userInfo:info];
    [delegate viewItem:self event:event];
   
    [self performSelector:@selector(deselectSearchText) withObject:nil afterDelay:0.01];
}

- (void)deselectSearchText {
    NSText * fieldEditor = [self.window fieldEditor:YES forObject:searchField];
    [fieldEditor setSelectedRange:NSMakeRange([[fieldEditor string] length], 0)];
    [fieldEditor setNeedsDisplay:YES];
}

@end
