//
//  GoodsContainerView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/23.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "GoodsContainerView.h"

@implementation GoodsContainerView
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
    NSArray *goodsList = [self fetch:@"goodsList"];
    for (NSDictionary *goods in goodsList) {
        [tableData addObject:@{
                                   @"id" : @"goods",
                                   @"type" : @"custom",
                                   @"height" : goods[@"height"],
                                   @"data" : goods,
                                   }];
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData,nil];

    //解决iOS7按钮移动
    [self.tableView reloadData];

}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    NSDictionary *goods = [cellData objectForKey:@"data"];
    int paddingTop = 5;
    UIView *superview = cell;
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = goods[@"name"];
    nameLabel.textColor = COLOR_MAIN_BLACK;
    nameLabel.font = FONT_MAIN;
    [cell addSubview:nameLabel];
    if ([@25 isEqualToValue:goods[@"height"]]){
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superview.mas_centerY);
            make.left.equalTo(superview.mas_left);
        }];
    } else {
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superview.mas_top).offset(paddingTop);
            make.left.equalTo(superview.mas_left);
            make.height.equalTo(@20);
        }];
    }
    
    //单价
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = goods[@"price"];
    priceLabel.textColor = COLOR_MAIN_BLACK;
    priceLabel.font = FONT_MAIN_BOLD;
    [cell addSubview:priceLabel];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(paddingTop);
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.height.equalTo(@20);
    }];
    
    //规格
    UILabel *specNameLabel = [[UILabel alloc] init];
    specNameLabel.text = goods[@"specName"];
    specNameLabel.textColor = COLOR_MAIN_GRAY;
    specNameLabel.font = FONT_MAIN;
    [cell addSubview:specNameLabel];
    
    [specNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(superview.mas_bottom).offset(-paddingTop);
        make.left.equalTo(superview.mas_left);
        make.height.equalTo(@20);
    }];
    
    //数量
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.text = goods[@"number"];
    numberLabel.textColor = COLOR_MAIN_GRAY;
    numberLabel.font = FONT_MAIN;
    [cell addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(superview.mas_bottom).offset(-paddingTop);
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.height.equalTo(@20);
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
