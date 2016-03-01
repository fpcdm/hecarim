//
//  AppTableView.m
//  LttMember
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@implementation BaseTableView (App)

- (void) customTableView
{
    //修正TabBar
    if (self.hasTabBar) {
        UIView *superview = self;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(superview.mas_bottom).offset(-TABBAR_HEIGHT);
        }];
    }
    
    //全局背景色
    self.tableView.backgroundColor = COLOR_MAIN_BG;
    self.tableView.scrollEnabled = NO;
}

- (BOOL) hasTabBar
{
    return NO;
}

@end

@implementation AppTableView

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
