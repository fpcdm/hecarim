//
//  UIScrollView+Framework.m
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UIScrollView+Framework.h"
#import "MJRefresh.h"

@implementation UIScrollView (Framework)

#pragma mark - emptyView
- (void)setEmptyView:(UIView *)emptyView
{
    // 默认隐藏
    if (emptyView) {
        emptyView.hidden = YES;
        [self addSubview:emptyView];
    }
    
    // 存储新的
    [self willChangeValueForKey:@"emptyView"]; // KVO
    [self setAssociatedObject:emptyView forKey:"emptyView"];
    [self didChangeValueForKey:@"emptyView"]; // KVO
}

- (UIView *)emptyView
{
    return [self getAssociatedObjectForKey:"emptyView"];
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
