//
//  AddressFormView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressFormView.h"
#import "AddressEntity.h"

@interface AddressFormView ()

@end

@implementation AddressFormView
{
    UITextField *nameField;
    UITextField *mobileField;
    UITextView *addressView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //初始化组件
    nameField = [[UITextField alloc] init];
    mobileField = [[UITextField alloc] init];
    addressView = [[UITextView alloc] init];
    
    return self;
}

- (void)renderData
{
    AddressEntity *address = [self getData:@"address"];
    NSString *area = address.provinceName ? [address areaName] : @"省，市，区";
    NSString *street = address.streetName ? address.streetName : @"街道";
    
    nameField.text = address.name;
    mobileField.text = address.mobile;
    addressView.text = address.address;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"name", @"type" : @"custom", @"view" : @"cellName:"},
                        @{@"id" : @"mobile", @"type" : @"custom", @"view" : @"cellMobile:"},
                        @{@"id" : @"area", @"type" : @"normal", @"text": area, @"font": [NSNumber numberWithFloat:SIZE_MIDDLE_TEXT]},
                        @{@"id" : @"street", @"type" : @"action", @"text": street, @"font": [NSNumber numberWithFloat:SIZE_MIDDLE_TEXT]},
                        @{@"id" : @"addres", @"type" : @"custom", @"view" : @"cellAddress:", @"height": @80},
                        ],
                      nil];
    [self.tableView reloadData];
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? HEIGHT_TABLE_MARGIN_DEFAULT : HEIGHT_TABLE_MARGIN_ZERO;
}

#pragma mark - Cell
- (UITableViewCell *)cellName:(UITableViewCell *)cell
{
    nameField.placeholder = @"联系人姓名";
    nameField.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [cell addSubview:nameField];
    
    //占位符用来定位
    cell.textLabel.text = @" ";
    
    UIView *superview = cell;
    [nameField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.bottom.equalTo(superview.mas_bottom);
        make.left.equalTo(cell.textLabel.mas_left);
        make.right.equalTo(superview.mas_right);
    }];
    
    return cell;
}

- (UITableViewCell *)cellMobile:(UITableViewCell *)cell
{
    mobileField.placeholder = @"手机号码";
    mobileField.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [cell addSubview:mobileField];
    
    //占位符用来定位
    cell.textLabel.text = @" ";
    
    UIView *superview = cell;
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.bottom.equalTo(superview.mas_bottom);
        make.left.equalTo(cell.textLabel.mas_left);
        make.right.equalTo(superview.mas_right);
    }];
    
    return cell;
}

- (UITableViewCell *)cellAddress:(UITableViewCell *)cell
{
    addressView.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [cell addSubview:addressView];
    
    //占位符用来定位
    cell.textLabel.text = @" ";
    
    UIView *superview = cell;
    [addressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.bottom.equalTo(superview.mas_bottom);
        make.left.equalTo(cell.textLabel.mas_left);
        make.right.equalTo(superview.mas_right);
    }];
    
    return cell;
}

#pragma mark - Action

@end
