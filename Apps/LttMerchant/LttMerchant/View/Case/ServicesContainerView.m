//
//  ServicesContainer.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/25.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "ServicesContainerView.h"

@implementation ServicesContainerView
{
    int padding;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    padding = 10;
    self.tableView.backgroundColor = COLOR_MAIN_WHITE;
    return self;
}


- (void)display
{
    //显示数据
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    NSArray *servicesList = [self fetch:@"servicesList"];
    for (NSDictionary *services in servicesList) {
        [tableData addObject:@{
                               @"id" : @"goods",
                               @"type" : @"custom",
                               @"height" : @25,
                               @"data" : services,
                               }];
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData,nil];
    //解决iOS7按钮移动
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    NSDictionary *services = [cellData objectForKey:@"data"];
    UIView *superView = cell;
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = services[@"name"];
    nameLabel.textColor = COLOR_MAIN_BLACK;
    nameLabel.font = FONT_MAIN;
    [cell addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.mas_centerY);
        make.left.equalTo(superView.mas_left);
    }];
    
    //单价
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = services[@"price"];
    priceLabel.textColor = COLOR_MAIN_BLACK;
    priceLabel.font = FONT_MAIN_BOLD;
    [superView addSubview:priceLabel];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.mas_centerY);
        make.right.equalTo(superView.mas_right).offset(-padding);
    }];
    
    return cell;
}

//让分割线左侧不留空白
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
