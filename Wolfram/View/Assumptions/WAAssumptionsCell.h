//
//  WAAssumptionsCell.h
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAViewItemCell.h"
#import "WAAssumptionPickerView.h"
#import "WAAssumptionIncludes.h"
#import "WAAssumptionInput.h"

@interface WAAssumptionsCell : WAViewItemCell {
    NSArray * assumptionViews;
}

- (id)initWithEventManager:(WAEventManager *)manager assumptions:(NSArray *)assumptions;

@end
