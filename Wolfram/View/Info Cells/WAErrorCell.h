//
//  WAErrorCell.h
//  Wolfram
//
//  Created by Alex Nichol on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewItemCell.h"
#import "CFAttributedStringHeight.h"

@interface WAErrorCell : WAViewItemCell {
    NSString * errorMessage;
    CFMutableAttributedStringRef drawString;
}

- (id)initWithEventManager:(WAEventManager *)manager error:(NSString *)error;

@end
