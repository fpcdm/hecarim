//
//  SafetyView.m
//  LttMember
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressSelectorView.h"

@implementation AddressSelectorView

#pragma mark - RenderData
- (void)renderData
{
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    NSMutableArray *addressList = [self getData:@"addressList"];
    AddressEntity *currentAddress = [self getData:@"currentAddress"];
    
    //当前地址存在
    if (currentAddress && currentAddress.address) {
        [tableData addObject:@{@"id" : @"address", @"type" : @"custom", @"action": @"actionSelected:", @"height":@90, @"data": currentAddress}];
    }
    
    //地址列表
    if (addressList != nil) {
        for (AddressEntity *address in addressList) {
            [tableData addObject:@{@"id" : @"address", @"type" : @"custom", @"action": @"actionSelected:", @"height":@90, @"data": address}];
        }
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData, nil];
    
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    AddressEntity *address = [cellData objectForKey:@"data"];
    BOOL isDefault = address.isDefault && [address.isDefault isEqualToNumber:@YES];
    BOOL isCurrent = !address.id ? YES : NO;
    
    //间距配置
    int padding = 10;
    UIView *superview = cell;
    UILabel *defaultLabel = nil;
    
    //是否默认或当前
    if (isDefault || isCurrent) {
        defaultLabel = [self makeCellLabel:isDefault ? @"[默认]" : @"[定位]"];
        defaultLabel.font = FONT_MAIN_BOLD;
        defaultLabel.backgroundColor = [UIColor clearColor];
        defaultLabel.textColor = COLOR_MAIN_BUTTON_BG;
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
        make.top.equalTo(superview.mas_top).offset(padding);
        if (isDefault || isCurrent) {
            make.left.equalTo(defaultLabel.mas_right);
        } else {
            make.left.equalTo(superview.mas_left).offset(padding);
        }
        
    }];
    
    //手机号
    UILabel *mobileLabel = [self makeCellLabel:address.mobile];
    [cell addSubview:mobileLabel];
    
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
    }];
    
    //地址显示
    if (!isCurrent) {
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
    //当前位置显示
    } else {
        //地址
        UILabel *addressLabel = [self makeCellLabel:address.address];
        addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        addressLabel.numberOfLines = 0;
        [cell addSubview:addressLabel];
        
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(mobileLabel.mas_bottom).offset(5);
            make.left.equalTo(superview.mas_left).offset(padding);
            make.right.equalTo(superview.mas_right).offset(-padding);
        }];
    }
    
    return cell;
}

//绘制cell中的label
- (UILabel *) makeCellLabel: (NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_MAIN;
    return label;
}

#pragma mark - Action
- (void)actionSelected:(NSDictionary *)cellData
{
    AddressEntity *address = [cellData objectForKey:@"data"];
    
    [self.delegate actionSelected:address];
}

@end
