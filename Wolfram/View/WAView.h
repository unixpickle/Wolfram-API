//
//  WAView.h
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "WAViewItem.h"
#import "WASearchCell.h"
#import "WAPodCell.h"
#import "WAScrollState.h"
#import "WAAssumptionsCell.h"

@class WAView;

@protocol WAViewDelegate <NSObject>

@optional
- (void)waView:(WAView *)view searchQuery:(NSString *)query;
- (void)waView:(WAView *)view assumptionSelected:(WAAssumptionValue *)assumption;

@end

@interface WAView : NSView <WAEventManagerTarget> {
    NSScrollView * scrollView;
    NSClipView * clipView;
    NSView * contentView;
    
    BOOL configuredNotifications;
    NSMutableArray * itemViews;
    WAEventManager * eventManager;
    
    NSMutableArray * scrollStates;
    
    __weak id<WAViewDelegate> delegate;
}

@property (nonatomic, weak) id<WAViewDelegate> delegate;

- (id)initWithFrame:(NSRect)frameRect;

- (void)addItem:(WAViewItem *)item;
- (WAViewItem *)addCell:(WAViewItemCell *)cell;
- (void)removeItems;
- (WASearchCell *)searchCell;
- (WAPodCell *)addPodCell:(WAPod *)aPod;
- (WAAssumptionsCell *)addAssumptionsCell:(NSArray *)assumptions;

- (void)saveScrollRect;
- (void)restoreScrollRect;

- (void)hookupWindowNotifications;
- (void)detachWindowNotifications;

@end
