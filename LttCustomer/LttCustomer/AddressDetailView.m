//
//  AddressDetailView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressDetailView.h"
#import "AddressEntity.h"

@implementation AddressDetailView
{
    AddressEntity *address;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //删除按钮
    UIButton *button = [AppUIUtil makeButton:@"删除" font:SIZE_MIDDLE_BUTTON_TEXT];
    [button addTarget:self action:@selector(actionDelete) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIView *superview = self;
    int padding = 10;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.tableView.tableFooterView.mas_bottom);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MIDDLE_BUTTON]);
    }];
    
    //设为默认按钮
    UIButton *defaultButton = [[UIButton alloc] init];
    [defaultButton setTitle:@"设为默认地址" forState:UIControlStateNormal];
    [defaultButton setTitleColor:[UIColor colorWithHexString:@"008000"] forState:UIControlStateNormal];
    defaultButton.titleLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_BUTTON_TEXT];
    defaultButton.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG];
    [defaultButton addTarget:self action:@selector(actionDefault) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:defaultButton];
    
    [defaultButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MIDDLE_BUTTON]);
    }];
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    address = [self getData:@"address"];
    NSString *name = address.name ? address.name : @"";
    NSString *mobile = address.mobile ? address.mobile : @"";
    NSString *area = [address areaName];
    NSString *street = address.streetName ? address.streetName : @"";
    NSString *addressName = address.address ? address.address : @"";
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"name", @"type" : @"custom", @"text" : @"联系人", @"data" : name},
                        @{@"id" : @"mobile", @"type" : @"custom", @"text" : @"手机号码", @"data" : mobile},
                        @{@"id" : @"area", @"type" : @"custom", @"text" : @"地区", @"data" : area},
                        @{@"id" : @"street", @"type" : @"custom", @"text" : @"街道", @"data" : street},
                        @{@"id" : @"addres", @"type" : @"custom", @"text" : @"地址", @"data" : addressName},
                        ],
                      nil];
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    
    //文本框
    UILabel *label = [[UILabel alloc] init];
    label.text = [cellData objectForKey:@"data"];
    label.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [cell addSubview:label];
    
    UIView *superview = cell;
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(80);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.centerY.equalTo(cell.textLabel.mas_centerY);
    }];
    
    return cell;
}

#pragma mark - Action
- (void)actionDelete
{
    [self.delegate actionDelete];
}

- (void)actionDefault
{
    [self.delegate actionDefault];
}

@end
