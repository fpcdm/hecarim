//
//  MJRefreshTableView.h
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "Samurai.h"

@interface MJRefreshTableView : UITableView

@signal( eventPullToRefresh );
@signal( eventLoadMore );

- (void) startRefreshing;

- (void) startLoading;

- (void) stopLoading: (BOOL) hasMore;

@end
