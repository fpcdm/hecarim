//
//  UIScrollView+RefreshLoading.m
//  LttCustomer
//
//  Created by wuyong on 15/5/5.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "UIScrollView+RefreshLoading.h"
#import "MJRefresh.h"

@implementation UIScrollView (RefreshLoading)

- (void) setRefreshHeader:(id)target action:(SEL)action
{
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.autoChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    self.header = header;
}

- (void) setLoadingFooter:(id)target action:(SEL)action
{
    //上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    self.footer = footer;
}

- (void)startRefresh
{
    [self.header beginRefreshing];
}

- (void) startLoading
{
    [self.footer beginRefreshing];
}

- (void) stopRefresh
{
    [self.header endRefreshing];
}

- (void) stopLoading:(BOOL)hasMore
{
    [self.footer endRefreshing];
    if (!hasMore) {
        [self.footer noticeNoMoreData];
    }
}

@end
