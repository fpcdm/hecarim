//
//  UIScrollView+RefreshLoading.h
//  LttCustomer
//
//  Created by wuyong on 15/5/5.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (RefreshLoading)

//下拉刷新
- (void) setRefreshHeader: (id) target action: (SEL) action;

- (void) startRefresh;

- (void) stopRefresh;

//上拉加载
- (void) setLoadingFooter: (id) target action: (SEL) action;

- (void) startLoading;

- (void) stopLoading: (BOOL) hasMore;

@end
