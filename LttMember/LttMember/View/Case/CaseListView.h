//
//  IntentionListView.h
//  LttMember
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"
#import "CaseEntity.h"
#import "UIScrollView+RefreshLoading.h"

@protocol CaseListViewDelegate <NSObject>

- (void)actionLoad:(UITableView *)tableView;
- (void)actionDetail:(CaseEntity *)intention;

@end

@interface CaseListView : AppTableView

@property (retain, nonatomic) id<CaseListViewDelegate> delegate;

@end
