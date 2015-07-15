//
//  CaseFormView.m
//  LttCustomer
//
//  Created by wuyong on 15/7/14.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseFormView.h"

@implementation CaseFormView
{
    UITextField *remarkField;
    UILabel *contactLabel;
    UITextView *addressTextView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"address", @"type" : @"custom", @"view": @"cellAddress:", @"action": @"actionAddress", @"height":@90},
                        ],
                      @[
                        @{@"id" : @"remark", @"type" : @"custom", @"view": @"cellRemark:"},
                        ],
                      nil];
    
    //呼叫按钮
    UIButton *button = [AppUIUtil makeButton:@"呼叫"];
    [button addTarget:self action:@selector(actionSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIView *superview = self;
    int padding = 10;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.tableView.tableFooterView.mas_bottom);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MIDDLE_BUTTON]);
    }];
    
    return self;
}

#pragma mark - RenderData
- (void) renderData
{
    NSString *name = [self getData:@"name"];
    if (!name) name = @"";
    NSString *mobile = [self getData:@"mobile"];
    NSString *address = [self getData:@"address"];
    if (!address) address = @"请选择服务地址";
    
    contactLabel.text = [NSString stringWithFormat:@"服务联系人：%@  %@", name, mobile];
    addressTextView.text = [NSString stringWithFormat:@"服务地址：%@", address];
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? HEIGHT_TABLE_MARGIN_DEFAULT : HEIGHT_TABLE_MARGIN_ZERO;
}

- (UITableViewCell *) cellAddress: (UITableViewCell *) cell
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"caseAddress"];
    [cell addSubview:imageView];
    
    float padding = 5;
    
    UIView *superview = cell;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(padding);
        make.centerY.equalTo(superview.mas_centerY);
        
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    //服务联系人
    contactLabel = [[UILabel alloc] init];
    contactLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [cell addSubview:contactLabel];
    
    padding = 10;
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(imageView.mas_right).offset(padding);
        
        make.height.equalTo(@20);
    }];
    
    //服务地址
    addressTextView = [[UITextView alloc] init];
    addressTextView.editable = NO;
    addressTextView.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    addressTextView.scrollEnabled = NO;
    [cell addSubview:addressTextView];
    
    [addressTextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(contactLabel.mas_bottom);
        make.left.equalTo(imageView.mas_right).offset(4);
        make.right.equalTo(superview.mas_right).offset(-24);
        make.bottom.equalTo(superview.mas_bottom).offset(-padding);
    }];
    
    return cell;
}

- (UITableViewCell *) cellRemark: (UITableViewCell *) cell
{
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"caseVoice"];
    [cell addSubview:imageView];
    
    float padding = 5;
    
    UIView *superview = cell;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(padding);
        make.centerY.equalTo(superview.mas_centerY);
        
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    //输入框
    remarkField = [AppUIUtil makeTextField];
    remarkField.placeholder = @"给客服留言";
    remarkField.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    remarkField.layer.borderColor = [UIColor colorWithHexString:COLOR_MAIN_BORDER].CGColor;
    remarkField.layer.borderWidth = 0.5f;
    [cell addSubview:remarkField];
    
    [remarkField mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@35);
    }];
    
    return cell;
}

#pragma mark - Action
- (void) actionAddress
{
    [self.delegate actionAddress];
}

- (void) actionSubmit
{
    [self.delegate actionSubmit:@""];
}

@end
