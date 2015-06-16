//
//  SafetyView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressView.h"
#import "AddressEntity.h"

@implementation AddressView

#pragma mark - RenderData
- (void)renderData
{
    NSMutableArray *addressList = [self getData:@"addressList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
    if (addressList != nil) {
        for (AddressEntity *address in addressList) {
            [tableData addObject:@{@"id" : @"address", @"type" : @"custom", @"action": @"", @"height":address.isDefault ? @100 : @80, @"data": address}];
        }
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData, nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    AddressEntity *address = [cellData objectForKey:@"data"];
    
    //间距配置
    int padding = 10;
    int paddingDefault = 30;
    UIView *superview = cell;
    CGFloat fontSize = SIZE_MIDDLE_TEXT;
    
    //是否默认
    if (address.isDefault) {
        UILabel *defaultLabel = [[UILabel alloc] init];
        defaultLabel.text = @"默认";
        defaultLabel.font = [UIFont systemFontOfSize:fontSize weight:1.0];
        [cell addSubview:defaultLabel];
        
        [defaultLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(superview.mas_top).offset(padding);
            make.left.equalTo(superview.mas_left).offset(padding);
        }];
    }
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = address.name;
    nameLabel.font = [UIFont systemFontOfSize:fontSize];
    [cell addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(address.isDefault ? paddingDefault : padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
    }];
    
    //手机号
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.text = address.mobile;
    mobileLabel.font = [UIFont systemFontOfSize:fontSize];
    [cell addSubview:mobileLabel];
    
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(address.isDefault ? paddingDefault : padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
    }];
    
    return cell;
}

@end
