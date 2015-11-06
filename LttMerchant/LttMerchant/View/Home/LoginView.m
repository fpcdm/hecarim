//
//  LoginView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/2.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
{
    UILabel *userLabel;
    UILabel *passwordLabel;
    UITextField *userField;
    UITextField *passwordField;
}

- (id)init{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    
    //视图
    UIView *uiView = [[UIView alloc] init];
    uiView.backgroundColor = COLOR_MAIN_WHITE;
    uiView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    uiView.layer.borderWidth = 0.5f;
    [self addSubview:uiView];
    
    [uiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(20);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@100);
    }];
    
    //账户
    userLabel = [[UILabel alloc] init];
    userLabel.text = @"账户";
    userLabel.font = FONT_MAIN;
    userLabel.textColor = COLOR_MAIN_BLACK;
    [uiView addSubview:userLabel];
    
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(uiView.mas_top).offset(15);
        make.left.equalTo(uiView.mas_left).offset(20);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    //账户输入框
    userField = [[UITextField alloc] init];
    userField.placeholder = @"请输入手机号";
    userField.font = FONT_MAIN;
    userField.textColor = COLOR_MAIN_BLACK;
    userField.clearButtonMode = UITextFieldViewModeAlways;
    userField.keyboardType = UIKeyboardTypeNumberPad;
    [uiView addSubview:userField];
    
    [userField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(uiView.mas_top).offset(15);
        make.left.equalTo(userLabel.mas_right);
        make.right.equalTo(uiView.mas_right);
        make.height.equalTo(@20);
    }];
    
    //分隔条
    UIView *borderView = [[UIView alloc] init];
    borderView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    borderView.layer.borderWidth = 0.5f;
    [uiView addSubview:borderView];
    
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLabel.mas_bottom).offset(15);
        make.left.equalTo(userLabel.mas_left);
        make.right.equalTo(uiView.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    //密码
    passwordLabel = [[UILabel alloc] init];
    passwordLabel.text = @"密码";
    passwordLabel.font = FONT_MAIN;
    passwordLabel.textColor = COLOR_MAIN_BLACK;
    [uiView addSubview:passwordLabel];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderView.mas_top).offset(15);
        make.left.equalTo(uiView.mas_left).offset(20);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    //密码输入框
    passwordField = [[UITextField alloc] init];
    passwordField.placeholder = @"请输入密码";
    passwordField.font = FONT_MAIN;
    passwordField.textColor = COLOR_MAIN_BLACK;
    passwordField.clearButtonMode = UITextFieldViewModeAlways;
    passwordField.secureTextEntry = YES;
    [uiView addSubview:passwordField];
    
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderView.mas_top).offset(15);
        make.left.equalTo(passwordLabel.mas_right);
        make.right.equalTo(uiView.mas_right);
        make.height.equalTo(@20);
    }];
    
    //找回密码
    UIButton *forgetPwdBtn = [[UIButton alloc] init];
    forgetPwdBtn.layer.borderColor = [UIColor clearColor].CGColor;
    forgetPwdBtn.layer.borderWidth = 0.0f;
    forgetPwdBtn.titleLabel.font = FONT_MIDDLE;
    [forgetPwdBtn addTarget:self action:@selector(actionForgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [forgetPwdBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [self addSubview:forgetPwdBtn];
    
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(uiView.mas_bottom).offset(10);
        make.right.equalTo(superView.mas_right).offset(-10);
        make.height.equalTo(@16);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"登陆"];
    [button addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetPwdBtn.mas_bottom).offset(10);
        make.left.equalTo(uiView.mas_left).offset(10);
        make.right.equalTo(uiView.mas_right).offset(-10);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];

    //商户注册
    UIButton *regBtn = [AppUIUtil makeButton:@"商户注册"];
    regBtn.backgroundColor = COLOR_MAIN_WHITE;
    regBtn.layer.borderWidth = 0.5f;
    regBtn.layer.borderColor = [UIColor colorWithHexString:@"0199FF"].CGColor;
    [regBtn setTitleColor:[UIColor colorWithHexString:@"0199FF"] forState:UIControlStateNormal];
    
    [regBtn addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:regBtn];
    
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(30);
        make.left.equalTo(uiView.mas_left).offset(10);
        make.right.equalTo(uiView.mas_right).offset(-10);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    return self;
}

//找回密码
- (void)actionForgetPassword
{
    [self.delegate actionForgetPassword];
}

//登录
- (void)actionLogin
{
    UserEntity *user = [[UserEntity alloc] init];
    user.mobile = userField.text;
    user.password = passwordField.text;
    [self.delegate actionLogin:user];
}

//商户注册
- (void)actionRegister
{
    [self.delegate actionRegister];
}

@end
