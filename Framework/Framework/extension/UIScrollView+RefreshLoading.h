//
//  UIScrollView+RefreshLoading.h
//  LttCustomer
//
//  Created by wuyong on 15/5/5.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

//刷新加载结果
typedef enum {
    //一条数据都没有
    RefreshLoadingStateNoData = 1,
    //数据未加载完毕
    RefreshLoadingStateMoreData,
    //全部加载完毕，没有更多数据
    RefreshLoadingStateNoMoreData
} RefreshLoadingState;

//定义刷新分类
@interface UIScrollView (RefreshLoading)

//空数据视图，不设置和没有更多效果一致
@property (strong, nonatomic) UIView *emptyView;

//下拉刷新
- (void) setRefreshingHeader: (id) target action: (SEL) action;

//上拉加载
- (void) setLoadingFooter: (id) target action: (SEL) action;

//开始刷新
- (void) startRefreshing;

//开始加载更多
- (void) startLoading;

//停止刷新加载
- (void) stopRefreshLoading;

//修改状态
- (void) setRefreshLoadingState:(RefreshLoadingState) state;

@end
