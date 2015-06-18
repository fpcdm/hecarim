//
//  AppTableView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@interface AppTableView ()

@end

@implementation AppTableView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //修正闪烁
    self.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    
    //全局背景色
    self.tableView.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    self.tableView.scrollEnabled = NO;
    
    return self;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    return view;
}

@end
