//
//  WAViewController.h
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAView.h"
#import "WAModel.h"

@interface WAViewController : NSObject <WAModelDelegate, WAViewDelegate> {
    WAView * view;
    WAModel * model;
}

@property (readonly) WAView * view;
@property (readonly) WAModel * model;

- (id)initWithView:(WAView *)aView model:(WAModel *)aModel;

- (void)handleSearchEvent:(WAViewEvent *)event;

@end
