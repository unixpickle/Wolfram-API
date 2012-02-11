//
//  WASearchCell.m
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WASearchCell.h"

@interface WASearchCell (Private)

- (void)deselectSearchText;

@end

@implementation WASearchCell

- (id)initWithEventManager:(WAEventManager *)manager title:(NSString *)aTitle {
    if ((self = [super initWithEventManager:manager title:aTitle])) {
        searchField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, self.frame.size.width - 20, 22)];
        [searchField setBezeled:YES];
        [searchField setBezelStyle:NSTextFieldSquareBezel];
        [searchField setTarget:self];
        [searchField setAction:@selector(searchEnter:)];
        [[searchField cell] setPlaceholderString:@"Search Query"];
        [self addSubview:searchField];
    }
    return self;
}

- (void)searchEnter:(id)sender {
    WAEvent * event = [WAEvent eventWithType:WAEventTypeSearch sender:self
                                      object:[searchField stringValue]
                                      forKey:kWAEventQueryUserInfoKey];
    [eventManager postEvent:event];
    [self performSelector:@selector(deselectSearchText) withObject:nil afterDelay:0.01];
}

- (void)deselectSearchText {
    NSText * fieldEditor = [self.window fieldEditor:YES forObject:searchField];
    [fieldEditor setSelectedRange:NSMakeRange([[fieldEditor string] length], 0)];
    [fieldEditor setNeedsDisplay:YES];
    [[self window] makeFirstResponder:self];
}

#pragma mark - Layout -

- (void)resizeToWidth:(CGFloat)width {
    NSRect frame = self.frame;
    frame.size.width = width;
    frame.size.height = 42;
    self.frame = frame;
    [searchField setFrame:NSMakeRect(10, 10, width - 20, 22)];
}

@end
