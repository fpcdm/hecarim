//
//  StaffListView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"
#import "StaffEntity.h"
#import "UIScrollView+RefreshLoading.h"

@protocol StaffListViewDelegate <NSObject>

- (void)actionLoadMore;

- (void)actionDetail:(StaffEntity *)staffEntity;

@end

@interface StaffListView : AppTableView

@property (retain, nonatomic) id<StaffListViewDelegate>delegate;

@end
