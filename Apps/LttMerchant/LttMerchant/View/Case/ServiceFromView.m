//
//  ServiceFromView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "ServiceFromView.h"
#import "CaseEntity.h"

@implementation ServiceFromView
{
    UILabel *caseNo;
    UILabel *statusName;
    UITextField *contentField;
    UITextField *priceField;
}

- (id)init{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    
    int padding = 10;
    
    //头部视图
    UIView *caseView = [[UIView alloc] init];
    caseView.backgroundColor = [UIColor colorWithHexString:@"8ed1f3"];
    [self addSubview:caseView];
    
    [caseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@50);
    }];
    
    //图片
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_icon_white"]];
    [caseView addSubview:image];

    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(caseView.mas_centerY);
        make.left.equalTo(caseView.mas_left).offset(padding);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    
    //编号
    UILabel *caseNoLabel = [[UILabel alloc] init];
    caseNoLabel.text = @"编号:";
    caseNoLabel.textColor = COLOR_MAIN_WHITE;
    caseNoLabel.font = FONT_MAIN;
    [caseView addSubview:caseNoLabel];
    
    [caseNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(caseView.mas_centerY);
        make.left.equalTo(image.mas_right).offset(padding);
    }];
    //编号NO
    caseNo = [[UILabel alloc] init];
    caseNo.textColor = COLOR_MAIN_WHITE;
    caseNo.font = FONT_MAIN;
    [caseView addSubview:caseNo];
    
    [caseNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(caseView.mas_centerY);
        make.left.equalTo(caseNoLabel.mas_right).offset(padding);
    }];
    
    //状态
    statusName = [[UILabel alloc] init];
    statusName.textColor = COLOR_MAIN_WHITE;
    statusName.font = FONT_MAIN;
    [caseView addSubview:statusName];
    
    [statusName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(caseView.mas_centerY);
        make.right.equalTo(caseView.mas_right).offset(-padding);
    }];
    
    //内容视图
    UIView *contentView = [UIView new];
    contentView.backgroundColor = COLOR_MAIN_WHITE;
    contentView.layer.borderWidth = 0.5f;
    contentView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@40);
    }];
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"内容";
    contentLabel.textColor = COLOR_MAIN_BLACK;
    contentLabel.font = FONT_MAIN;
    [contentView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView.mas_centerY);
        make.left.equalTo(contentView.mas_left).offset(padding);
        make.width.equalTo(@45);
    }];
    
    //内容输入框
    contentField = [[UITextField alloc] init];
    contentField.placeholder = @"请输入内容";
    contentField.textColor = COLOR_MAIN_BLACK;
    contentField.font = FONT_MAIN;
    contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [contentView addSubview:contentField];
    
    [contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView.mas_centerY);
        make.left.equalTo(contentLabel.mas_right);
        make.right.equalTo(contentView.mas_right).offset(-padding);
    }];
    
    //价格视图
    UIView *priceView = [UIView new];
    priceView.backgroundColor = COLOR_MAIN_WHITE;
    priceView.layer.borderWidth = 0.5f;
    priceView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [self addSubview:priceView];
    
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@40);
    }];
    
    //价格
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"价格";
    priceLabel.textColor = COLOR_MAIN_BLACK;
    priceLabel.font = FONT_MAIN;
    [priceView addSubview:priceLabel];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceView.mas_centerY);
        make.left.equalTo(priceView.mas_left).offset(padding);
        make.width.equalTo(@45);
    }];
    
    //价格输入框
    priceField = [[UITextField alloc] init];
    priceField.placeholder = @"请输入价格";
    priceField.textColor = COLOR_MAIN_BLACK;
    priceField.font = FONT_MAIN;
    priceField.clearButtonMode = UITextFieldViewModeWhileEditing;
    priceField.keyboardType = UIKeyboardTypeDecimalPad;
    [priceView addSubview:priceField];
    
    [priceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceView.mas_centerY);
        make.left.equalTo(priceLabel.mas_right);
        make.right.equalTo(priceView.mas_right).offset(-padding);
    }];
    
    //保存
    UIButton *button = [AppUIUtil makeButton:@"提交订单"];
    [button addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];

    
    return self;
}

- (void)actionSave
{
    [self.delegate actionSave:contentField.text price:priceField.text];
}

- (void)display
{
    CaseEntity *caseEntity = [self fetch:@"caseEntity"];
    caseNo.text = caseEntity.no;
    statusName.text = [caseEntity statusName];
}

@end
