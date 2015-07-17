//
//  SafetyView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressSelectorView.h"

@implementation AddressSelectorView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableData = [[NSMutableArray alloc] init];
    
    //退出按钮
    UIButton *button = [AppUIUtil makeButton:@"使用当前位置"];
    [button addTarget:self action:@selector(actionSelectedPosition) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIView *superview = self;
    int padding = 10;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.tableView.tableFooterView.mas_bottom);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    //解决iOS7按钮移动
    [self.tableView reloadData];
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    NSMutableArray *addressList = [self getData:@"addressList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
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
    
    //间距配置
    int padding = 10;
    UIView *superview = cell;
    UILabel *defaultLabel = nil;
    
    //是否默认
    if (isDefault) {
        defaultLabel = [self makeCellLabel:@"[默认]"];
        defaultLabel.font = [UIFont boldSystemFontOfSize:SIZE_MAIN_TEXT];
        defaultLabel.backgroundColor = [UIColor clearColor];
        defaultLabel.textColor = [UIColor colorWithHexString:COLOR_MAIN_BUTTON_BG];
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
    label.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    return label;
}

#pragma mark - Action
- (void)actionSelected:(NSDictionary *)cellData
{
    AddressEntity *address = [cellData objectForKey:@"data"];
    
    [self.delegate actionSelected:address];
}

- (void)actionSelectedPosition
{
    [self.delegate actionSelected:nil];
}

@end
