//
//  WAAssumptionPickerView.h
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WAAssumptionView.h"

@interface WAAssumpViewPicker : WAAssumptionView {
    NSPopUpButton * popupButton;
}

- (void)popupButtonChanged:(id)sender;

@end
