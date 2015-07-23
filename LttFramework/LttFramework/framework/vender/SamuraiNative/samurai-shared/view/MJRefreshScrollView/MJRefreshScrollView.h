//
//  MJRefreshScrollView.h
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "Samurai.h"
#import "UIScrollView+RefreshLoading.h"

@interface UIScrollView (MJRefreshSamurai)

@signal( eventPullToRefresh );

@signal( eventLoadMore );

- (void) loadRefreshingHeader;

- (void) loadLoadingFooter;

@end
