//
//  BalanceListView.h
//  LttMember
//
//  Created by 杨海锋 on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol BalanceListViewDelegate <NSObject>

- (void)actionLoad:(UITableView *)tableView;

@end

@interface BalanceListView : AppTableView

@property (retain , nonatomic) id<BalanceListViewDelegate>delegate;

@end
