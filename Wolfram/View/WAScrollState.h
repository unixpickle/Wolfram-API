//
//  WAScrollState.h
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WAScrollState : NSObject {
    NSRect visibleRect;
    CGFloat contentHeight;
}

@property (readonly) NSRect visibleRect;
@property (readonly) CGFloat contentHeight;

- (id)initWithVisibleRect:(NSRect)vRect contentHeight:(CGFloat)height;

@end
