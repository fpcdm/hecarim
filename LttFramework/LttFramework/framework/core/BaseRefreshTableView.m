//
//  BaseRefreshTableView.m
//  LttFramework
//
//  Created by wuyong on 15/7/8.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseRefreshTableView.h"
#import "MJRefresh.h"

@implementation BaseRefreshTableView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //允许滚动
    self.tableView.scrollEnabled = YES;
    
    //下拉刷新
    if ([self pullToRefresh]) {
        //下拉刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(actionPullRefresh)];
        header.autoChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
        self.tableView.header = header;
    }
    
    //上拉加载
    if ([self dropToRefresh]) {
        // 上拉加载更多
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(actionDropRefresh)];
        [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
        self.tableView.footer = footer;
    }
    
    //自定义刷新视图钩子，子类可以实现(不会影响别的子类)，也可以利用类分类实现(会影响别的子类)
    if ([self respondsToSelector:@selector(customRefreshTableView)]) {
        [self performSelector:@selector(customRefreshTableView)];
    }
    
    //开始加载
    if ([self pullToRefresh]) {
        [self.tableView.header beginRefreshing];
    } else if ([self dropToRefresh]) {
        [self.tableView.footer beginRefreshing];
    }
    
    return self;
}

- (BOOL) pullToRefresh
{
    return NO;
}

- (BOOL) dropToRefresh
{
    return NO;
}

- (void) actionPullRefresh
{
    [self pullRefresh:^(BOOL status){
        [self.tableView.header endRefreshing];
    }];
}

- (void) actionDropRefresh
{
    [self dropRefresh:^(BOOL status){
        [self.tableView.footer endRefreshing];
        if (!status) {
            [self.tableView.footer noticeNoMoreData];
        }
    }];
}

- (void) pullRefresh:(RefreshCompletionHandler) completionHandler;
{
    completionHandler(YES);
}

- (void) dropRefresh:(RefreshCompletionHandler) completionHandler;
{
    completionHandler(YES);
}

@end
