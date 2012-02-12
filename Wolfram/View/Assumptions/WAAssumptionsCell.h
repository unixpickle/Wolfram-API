//
//  WAAssumptionsCell.h
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewItemCell.h"
#import "WAAssumpViewPicker.h"
#import "WAAssumpViewInclude.h"
#import "WAAssumpViewInput.h"

@interface WAAssumptionsCell : WAViewItemCell {
    NSArray * assumptionViews;
}

- (id)initWithEventManager:(WAEventManager *)manager assumptions:(NSArray *)assumptions;

@end
