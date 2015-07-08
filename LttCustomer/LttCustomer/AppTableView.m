//
//  AppTableView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@implementation BaseTableView (App)

- (void) customTableView
{
    //全局背景色
    self.tableView.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    self.tableView.scrollEnabled = NO;
}

@end

@implementation AppTableView

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    return view;
}

@end

@implementation AppRefreshTableView

@end
