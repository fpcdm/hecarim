//
//  ConsumeHistoryView.h
//  LttMerchant
//
//  Created by wuyong on 15/9/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"
#import "UIScrollView+RefreshLoading.h"

@protocol ConsumeHistoryViewDelegate <NSObject>

- (void)actionContact;
- (void)actionLoadMore;

@end

@interface ConsumeHistoryView : AppTableView

@property (retain, nonatomic) id<ConsumeHistoryViewDelegate> delegate;

@end
