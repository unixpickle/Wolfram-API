//
//  WAMutableRequest.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WARequest.h"

@interface WAMutableRequest : WARequest <NSCopying, NSMutableCopying> {
    
}

- (void)setQuery:(NSString *)aQuery;
- (void)setAPIKey:(NSString *)aKey;

- (void)addAssumption:(WARequestAssumption *)assumption;
- (void)addPodState:(WARequestPodState *)podState;
- (void)removeAssumption:(WARequestAssumption *)assumption;
- (void)removePodState:(WARequestPodState *)podState;

@end
