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

#pragma mark - NoDataView
static const char RefreshLoadingEmptyViewKey = '\0';
- (void)setEmptyView:(UIView *)emptyView
{
    if (emptyView != self.emptyView) {
        // 删除旧的，添加新的
        if (self.emptyView) {
            [self.emptyView removeFromSuperview];
        }
        // 默认隐藏
        if (emptyView) {
            emptyView.hidden = YES;
            [self addSubview:emptyView];
        }
        
        // 存储新的
        [self willChangeValueForKey:@"noDataView"]; // KVO
        objc_setAssociatedObject(self, &RefreshLoadingEmptyViewKey, emptyView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"noDataView"]; // KVO
    }
}

- (UIView *)emptyView
{
    return objc_getAssociatedObject(self, &RefreshLoadingEmptyViewKey);
}

#pragma mark - RefreshLoading
- (void) setRefreshingHeader:(id)target action:(SEL)action
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

- (void)startRefreshing
{
    [self.header beginRefreshing];
}

- (void) startLoading
{
    [self.footer beginRefreshing];
}

- (void) stopRefreshLoading
{
    if (self.header && [self.header isRefreshing]) {
        [self.header endRefreshing];
    }
    if (self.footer && [self.footer isRefreshing]) {
        [self.footer endRefreshing];
    }
}

- (void) setRefreshLoadingState:(RefreshLoadingState)state
{
    switch (state) {
        case RefreshLoadingStateNoData:
        {
            [self.footer noticeNoMoreData];
            if (self.emptyView) {
                self.footer.hidden = YES;
                self.emptyView.hidden = NO;
            }
        }
            break;
        case RefreshLoadingStateNoMoreData:
        {
            [self.footer noticeNoMoreData];
            if (self.emptyView) {
                self.emptyView.hidden = YES;
                self.footer.hidden = NO;
            }
        }
            break;
        default:
        {
            [self.footer resetNoMoreData];
            if (self.emptyView) {
                self.emptyView.hidden = YES;
                self.footer.hidden = NO;
            }
        }
            break;
    }
}

@end
