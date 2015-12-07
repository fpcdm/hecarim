//
//  SafetyView.m
//  LttMember
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressView.h"

@implementation AddressView

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    //空视图
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    emptyView.backgroundColor = COLOR_MAIN_BG;
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 20)];
    emptyLabel.text = @"暂时没有可用服务地址";
    emptyLabel.font = FONT_MAIN;
    emptyLabel.textColor = COLOR_MAIN_DARK;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    [emptyView addSubview:emptyLabel];
    
    self.tableView.tableFooterView = emptyView;
    self.tableView.tableFooterView.hidden = YES;
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    NSMutableArray *addressList = [self getData:@"addressList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
    //有数据
    if (addressList != nil && [addressList count] > 0) {
        for (AddressEntity *address in addressList) {
            [tableData addObject:@{@"id" : @"address", @"type" : @"custom", @"action": @"actionDetail:", @"height":@90, @"data": address}];
        }
        
        self.tableView.tableFooterView.hidden = YES;
        self.tableView.scrollEnabled = YES;
    //空数据
    } else {
        self.tableView.tableFooterView.hidden = NO;
        self.tableView.scrollEnabled = NO;
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
    UIView *superview = cell;
    UILabel *defaultLabel = nil;
    
    //是否默认
    if (isDefault) {
        defaultLabel = [self makeCellLabel:@"[默认]"];
        defaultLabel.backgroundColor = [UIColor clearColor];
        defaultLabel.font = FONT_MAIN_BOLD;
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
        if (isDefault) {
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
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_MAIN;
    return label;
}

#pragma mark - Action
- (void)actionDetail:(NSDictionary *)cellData
{
    AddressEntity *address = [cellData objectForKey:@"data"];
    
    [self.delegate actionDetail:address];
}

@end
