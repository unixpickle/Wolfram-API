//
//  WAAssumptionView.h
//  Wolfram
//
//  Created by Alex Nichol on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAEventManager.h"

@protocol WAAssumptionView <NSObject>

@property (nonatomic, weak) WAEventManager * eventManager;

- (void)resizeToWidth:(CGFloat)width;

@end
