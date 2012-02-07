//
//  WAModel.h
//  Wolfram
//
//  Created by Nichol, Alexander on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAPod.h"
#import "WAAssumption.h"

@class WAModel;

@protocol WAModelDelegate <NSObject>

- (void)model:(WAModel *)model loadedPod:(WAPod *)aPod;
- (void)model:(WAModel *)model loadedAssumptions:(NSArray *)assumptions;
- (void)model:(WAModel *)model failedToLoad:(NSError *)error;

@end

@interface WAModel : NSObject {
    
}


@end
