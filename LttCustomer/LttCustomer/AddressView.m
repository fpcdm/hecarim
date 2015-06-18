//
//  SafetyView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressView.h"

@implementation AddressView

#pragma mark - RenderData
- (void)renderData
{
    NSMutableArray *addressList = [self getData:@"addressList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
    if (addressList != nil) {
        for (AddressEntity *address in addressList) {
            BOOL isDefault = address.isDefault && [address.isDefault isEqualToNumber:@YES];
            [tableData addObject:@{@"id" : @"address", @"type" : @"custom", @"action": @"actionDetail:", @"height":isDefault ? @110 : @90, @"data": address}];
        }
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData, nil];
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    AddressEntity *address = [cellData objectForKey:@"data"];
    BOOL isDefault = address.isDefault && [address.isDefault isEqualToNumber:@YES];
    
    //间距配置
    int padding = 10;
    int paddingDefault = 30;
    UIView *superview = cell;
    
    //是否默认
    if (isDefault) {
        UILabel *defaultLabel = [self makeCellLabel:@"默认"];
        defaultLabel.font = [UIFont boldSystemFontOfSize:SIZE_MAIN_TEXT];
        [cell addSubview:defaultLabel];
        
        [defaultLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(superview.mas_top).offset(padding);
            make.left.equalTo(superview.mas_left).offset(padding);
        }];
    }
    
    //姓名
    UILabel *nameLabel = [self makeCellLabel:address.name];
    [cell addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(isDefault ? paddingDefault : padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
    }];
    
    //手机号
    UILabel *mobileLabel = [self makeCellLabel:address.mobile];
    [cell addSubview:mobileLabel];
    
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(isDefault ? paddingDefault : padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
    }];
    
    //区域
    NSString *areaText = [NSString stringWithFormat:@"%@ %@", [address areaName], address.streetName ? address.streetName : @""];
    UILabel *areaLabel = [self makeCellLabel:areaText];
    [cell addSubview:areaLabel];
    
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.left.equalTo(superview.mas_left).offset(padding);
        
    }];
    
    //地址
    UILabel *addressLabel = [self makeCellLabel:address.address];
    [cell addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(areaLabel.mas_bottom).offset(5);
        make.left.equalTo(superview.mas_left).offset(padding);
        
    }];
    
    return cell;
}

//绘制cell中的label
- (UILabel *) makeCellLabel: (NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    return label;
}

#pragma mark - Action
- (void)actionDetail:(NSDictionary *)cellData
{
    AddressEntity *address = [cellData objectForKey:@"data"];
    
    [self.delegate actionDetail:address];
}

@end
