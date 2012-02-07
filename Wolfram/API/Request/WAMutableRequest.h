//
//  WAMutableRequest.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WARequest.h"
#import "WAAssumption.h"
#import "WAPodStateList.h"

@interface WAMutableRequest : WARequest <NSCopying, NSMutableCopying> {
    
}

- (void)setQuery:(NSString *)aQuery;
- (void)setAPIKey:(NSString *)aKey;

- (void)addAssumption:(NSString *)assumption;
- (void)addPodState:(NSString *)podState;
- (void)removeAssumption:(NSString *)assumption;
- (void)removePodState:(NSString *)podState;
- (void)selectAssumptionValue:(WAAssumptionValue *)value;
- (void)selectPodState:(WAPodState *)podState;

@end
