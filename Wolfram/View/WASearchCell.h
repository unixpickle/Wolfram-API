//
//  WASearchCell.h
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewItemCell.h"

@interface WASearchCell : WAViewItemCell {
    NSTextField * searchField;
}

- (void)searchEnter:(id)sender;

@end
