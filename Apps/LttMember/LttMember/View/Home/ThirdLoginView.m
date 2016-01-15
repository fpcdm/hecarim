//
//  ThirdLoginView.m
//  LttMember
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ThirdLoginView.h"

@implementation ThirdLoginView
{
    UITextField *mobileField;
    UITextField *codeField;
}

@synthesize sendButton;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    
    //提示
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"为方便服务人员及时联系您，请验证手机";
    tipLabel.font = FONT_MAIN;
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(10);
        make.centerX.equalTo(superView.mas_centerX);
        make.height.equalTo(@20);
    }];
    
    //输入视图
    UIView *inputView = [UIView new];
    inputView.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    inputView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    inputView.layer.borderWidth = 0.5f;
    [self addSubview:inputView];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@50);
    }];
    
    //输入框名称
    UILabel *inputLabel = [[UILabel alloc] init];
    inputLabel.text = @"手机号";
    inputLabel.font = FONT_MAIN;
    [inputView addSubview:inputLabel];
    
    [inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputView.mas_left).offset(10);
        make.centerY.equalTo(inputView.mas_centerY);
        make.width.equalTo(@50);
    }];
    
    //手机号输入框
    mobileField = [AppUIUtil makeTextField];
    mobileField.placeholder = @"请输入手机号";
    mobileField.font = FONT_MAIN;
    mobileField.clearButtonMode = YES;
    mobileField.keyboardType = UIKeyboardTypePhonePad;
    [inputView addSubview:mobileField];
    
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputLabel.mas_right);
        make.centerY.equalTo(inputView.mas_centerY);
        make.height.equalTo(@40);
        make.width.equalTo(inputView.mas_width).offset(-160);
    }];
    
    //间隔
    UIView *borderView = [[UIView alloc] init];
    borderView.backgroundColor = COLOR_MAIN_BORDER;
    [inputView addSubview:borderView];
    
    [borderView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(inputView.mas_centerY);
        make.left.equalTo(mobileField.mas_right);
        make.height.equalTo(@25);
        make.width.equalTo(@1);
    }];
    
    //发送短信按钮
    sendButton = [[UIButton alloc] init];
    [sendButton setTitle:@"发送短信" forState:UIControlStateNormal];
    [sendButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(actionSendCode) forControlEvents:UIControlEventTouchUpInside];
    sendButton.titleLabel.font = FONT_MAIN;
    sendButton.titleLabel.backgroundColor = [UIColor clearColor];
    sendButton.backgroundColor = COLOR_MAIN_BG;
    sendButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    sendButton.layer.cornerRadius = 4.0f;
    sendButton.layer.borderWidth = 0.5f;
    [inputView addSubview:sendButton];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(borderView.mas_right).offset(5);
        make.right.equalTo(inputView.mas_right).offset(-10);
        make.centerY.equalTo(inputView.mas_centerY);
        make.height.equalTo(@40);
    }];
    
    //输入视图
    UIView *codeView = [UIView new];
    codeView.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    codeView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    codeView.layer.borderWidth = 0.5f;
    [self addSubview:codeView];
    
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).offset(10);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@50);
    }];
    
    //输入框名称
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.text = @"验证码";
    codeLabel.font = FONT_MAIN;
    [codeView addSubview:codeLabel];
    
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView.mas_left).offset(10);
        make.centerY.equalTo(codeView.mas_centerY);
        make.width.equalTo(@50);
    }];
    
    //校验码输入框
    codeField = [AppUIUtil makeTextField];
    codeField.placeholder = @"请输入验证码";
    codeField.font = FONT_MAIN;
    codeField.clearButtonMode = YES;
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    [codeView addSubview:codeField];
    
    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeLabel.mas_right);
        make.right.equalTo(codeView.mas_right).offset(-10);
        make.centerY.equalTo(codeView.mas_centerY);
        make.height.equalTo(@40);
    }];
    
    //确定按钮
    UIButton *button = [AppUIUtil makeButton:@"确定"];
    [button addTarget:self action:@selector(actionVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    superView = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(codeView.mas_bottom).offset(10);
        make.left.equalTo(superView.mas_left).offset(10);
        make.right.equalTo(superView.mas_right).offset(-10);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    return self;
}

#pragma mark - Action
- (void)actionSendCode
{
    [self.delegate actionSendCode:mobileField.text];
}

- (void)actionVerifyCode
{
    [mobileField resignFirstResponder];
    [codeField resignFirstResponder];
    
    [self.delegate actionVerifyCode:mobileField.text code:codeField.text];
}

@end
