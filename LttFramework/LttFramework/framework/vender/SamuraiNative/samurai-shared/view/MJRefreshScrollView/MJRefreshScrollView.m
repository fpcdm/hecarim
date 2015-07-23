//
//  MJRefreshScrollView.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "MJRefreshScrollView.h"

@implementation UIScrollView (MJRefreshSamurai)

@def_signal( eventPullToRefresh );
@def_signal( eventLoadMore );

- (void) loadRefreshingHeader
{
    [self setRefreshingHeader:self action:@selector(actionPullToRefresh)];
}

- (void) loadLoadingFooter
{
    [self setLoadingFooter:self action:@selector(actionLoadMore)];
}

- (void) actionPullToRefresh
{
    [self sendSignal:self.eventPullToRefresh];
}

- (void) actionLoadMore
{
    [self sendSignal:self.eventLoadMore];
}

@end
