//
//  BaseRefreshTableView.h
//  LttFramework
//
//  Created by wuyong on 15/7/8.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseTableView.h"

/**
 *  刷新结束回调句柄
 */
typedef void (^RefreshCompletionHandler)(BOOL status);

@interface BaseRefreshTableView : BaseTableView

- (BOOL) pullToRefresh;

- (BOOL) dropToRefresh;

//下拉刷新句柄，子类重写，completionHandler刷新结束回调，子类可通过delegate代理
- (void) pullRefresh:(RefreshCompletionHandler) completionHandler;

//上拉加载更多句柄，子类重写，completionHandler加载结束回调，YES还有更多数据，NO没有更多数据，子类可通过delegate代理
- (void) dropRefresh:(RefreshCompletionHandler) completionHandler;

@end
