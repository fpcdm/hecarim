//
//  AddressFormView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressFormView.h"
#import "AddressEntity.h"
#import "TPKeyboardAvoidingTableView.h"

@interface AddressFormView () <UITextViewDelegate>

@end

@implementation AddressFormView

@synthesize nameField;

@synthesize mobileField;

@synthesize addressView;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //初始化组件
    nameField = [[UITextField alloc] init];
    self.nameField = nameField;
    
    mobileField = [[UITextField alloc] init];
    self.mobileField = mobileField;
    
    addressView = [[UITextView alloc] init];
    self.addressView = addressView;
    
    return self;
}

- (void)renderData
{
    AddressEntity *address = [self getData:@"address"];
    NSString *area = address.provinceName ? [address areaName] : @"省，市，区";
    NSString *street = address.streetName ? address.streetName : @"街道";
    
    if (!nameField.text || [nameField.text length] < 1) {
        nameField.text = address.name;
    }
    if (!mobileField.text || [mobileField.text length] < 1) {
        mobileField.text = address.mobile;
    }
    if (!addressView.text || [addressView.text length] < 1) {
        addressView.text = address.address;
    }
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"name", @"type" : @"custom", @"view" : @"cellName:"},
                        @{@"id" : @"mobile", @"type" : @"custom", @"view" : @"cellMobile:"},
                        @{@"id" : @"area", @"type" : @"action", @"action": @"actionArea", @"text": area},
                        @{@"id" : @"street", @"type" : @"action", @"action" : @"actionStreet", @"text": street},
                        @{@"id" : @"addres", @"type" : @"custom", @"view" : @"cellAddress:", @"height": @80},
                        ],
                      nil];
    [self.tableView reloadData];
}

#pragma mark - TableView
//初始化TableView
-(UITableView *)loadTableView
{
    TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:[self bounds] style:UITableViewStyleGrouped];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER_DEFAULT];
    return tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? HEIGHT_TABLE_MARGIN_DEFAULT : HEIGHT_TABLE_MARGIN_ZERO;
}

#pragma mark - Cell
- (UITableViewCell *)cellName:(UITableViewCell *)cell
{
    nameField.placeholder = @"联系人姓名";
    nameField.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
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
    mobileField.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    mobileField.keyboardType = UIKeyboardTypePhonePad;
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
    addressView.placeholder = @"详细地址";
    addressView.delegate = self;
    addressView.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [cell addSubview:addressView];
    
    UIView *superview = cell;
    [addressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.bottom.equalTo(superview.mas_bottom);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right);
    }];
    
    return cell;
}

#pragma mark - TextView
//回车关闭键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Action
- (void)actionArea
{
    [self.delegate actionArea];
}

- (void)actionStreet
{
    [self.delegate actionStreet];
}

@end
