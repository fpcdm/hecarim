//
//  MJRefreshTableView.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "MJRefreshTableView.h"
#import "MJRefresh.h"

@implementation MJRefreshTableView

@def_signal( eventPullToRefresh );
@def_signal( eventLoadMore );

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (!self) return nil;
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(actionPullRefresh)];
    header.autoChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    self.header = header;
    
    //上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(actionDropRefresh)];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    self.footer = footer;
    
    return self;
}

- (void)startRefreshing
{
    [self.header beginRefreshing];
}

- (void) startLoading
{
    [self.footer beginRefreshing];
}

- (void) stopLoading:(BOOL)hasMore
{
    [self.header endRefreshing];
    [self.footer endRefreshing];
    if (!hasMore) {
        [self.footer noticeNoMoreData];
    }
}

- (void) actionPullRefresh
{
    [self sendSignal:self.eventPullToRefresh];
}

- (void) actionDropRefresh
{
    [self sendSignal:self.eventLoadMore];
}

@end
