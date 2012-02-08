//
//  WAModel.h
//  Wolfram
//
//  Created by Nichol, Alexander on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAMutableRequest.h"
#import "WAModelQuery.h"
#import "WAModelPodQuery.h"

#define kAPIKey @"HGGPA6-LRPYV5Q2Y6"

@class WAModel;

@protocol WAModelDelegate <NSObject>

@optional
- (void)model:(WAModel *)model gotResponse:(WAResponse *)response;
- (void)model:(WAModel *)model gotAssumptions:(NSArray *)assumptions;
- (void)model:(WAModel *)model gotPod:(WAPod *)pod;
- (void)model:(WAModel *)model failedToLoad:(NSError *)error;
- (void)modelFinishedAllQueries:(WAModel *)model;

@end

@interface WAModel : NSObject <WAModelRequestDelegate> {
    NSMutableArray * requests;
    WARequest * currentPage;
    __weak id<WAModelDelegate> delegate;
}

@property (nonatomic, weak) __weak id<WAModelDelegate> delegate;

- (void)searchQuery:(NSString *)aQuery;
- (void)applyAssumption:(WAAssumptionValue *)assumption;
- (void)applyState:(WAPodState *)state forPod:(WAPod *)aPod;
- (void)cancelRequests;
- (BOOL)isFinished;

@end
