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

- (NSDictionary *)tableView:(UITableView *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell;

@end
