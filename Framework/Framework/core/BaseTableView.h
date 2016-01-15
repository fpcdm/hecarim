//
//  BaseTableView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseView.h"

@interface BaseTableView : BaseView <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;

@property (retain, nonatomic) NSMutableArray *tableData;

//加载主TableView
- (UITableView *)loadTableView;

//加载可重用TableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView loadReuseTableViewCell:(NSIndexPath *)indexPath;

//获取TableViewCell数据
- (NSDictionary *)tableView:(UITableView *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath;

//自定义TableViewCell视图
- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell;

@end
