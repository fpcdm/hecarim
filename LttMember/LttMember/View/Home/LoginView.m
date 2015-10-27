//
//  LoginView.m
//  LttMember
//
//  Created by wuyong on 15/6/12.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
{
    UITextField *mobileField;
    UITextField *passwordField;
    UIButton *button;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //输入视图
    UIView *inputView = [UIView new];
    inputView.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    inputView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    inputView.layer.borderWidth = 0.5f;
    [self addSubview:inputView];
    
    UIView *superview = self;
    int padding = 10;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(20);
        make.left.equalTo(superview.mas_left).offset(-0.5);
        make.right.equalTo(superview.mas_right).offset(0.5);
        
        make.height.equalTo(@100);
    }];
    
    //账户
    UILabel *accountLabel = [UILabel new];
    accountLabel.text = @"账户";
    accountLabel.font = FONT_MAIN;
    [inputView addSubview:accountLabel];
    
    superview = inputView;
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(20);
        make.top.equalTo(superview.mas_top).offset(padding);
        
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    
    //手机号输入框
    mobileField = [AppUIUtil makeTextField];
    mobileField.keyboardType = UIKeyboardTypePhonePad;
    mobileField.placeholder = @"请输入手机号";
    mobileField.font = FONT_MAIN;
    [inputView addSubview:mobileField];
    
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(accountLabel.mas_right);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@30);
    }];
    
    //间隔
    UIView *borderView = [[UIView alloc] init];
    borderView.backgroundColor = COLOR_MAIN_BORDER;
    [inputView addSubview:borderView];
    
    [borderView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(accountLabel.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo(@0.5);
    }];
    
    //密码
    UILabel *passwordLabel = [UILabel new];
    passwordLabel.text = @"密码";
    passwordLabel.font = FONT_MAIN;
    [inputView addSubview:passwordLabel];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(accountLabel.mas_left);
        make.top.equalTo(borderView.mas_bottom).offset(padding);
        
        make.width.equalTo(accountLabel.mas_width);
        make.height.equalTo(accountLabel.mas_height);
    }];
    
    //密码输入框
    passwordField = [AppUIUtil makeTextField];
    passwordField.placeholder = @"请输入密码";
    passwordField.secureTextEntry = YES;
    passwordField.font = FONT_MAIN;
    [inputView addSubview:passwordField];
    
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(borderView.mas_bottom).offset(padding);
        make.left.equalTo(mobileField.mas_left);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@30);
    }];
    
    //按钮
    button = [AppUIUtil makeButton:@"登陆"];
    [button addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    superview = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(inputView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];

    //找回密码
    UIButton *findPwdBtn = [[UIButton alloc] init];
    [findPwdBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [findPwdBtn addTarget:self action:@selector(actionFindPwd) forControlEvents:UIControlEventTouchUpInside];
    findPwdBtn.titleLabel.font = FONT_MAIN;
    findPwdBtn.layer.cornerRadius = 0.0f;
    findPwdBtn.layer.borderWidth = 0.0f;
    [self addSubview:findPwdBtn];
    
    
    [findPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
    }];

    
    return self;
}

- (void)actionLogin
{
    //记录用户信息
    UserEntity *user = [[UserEntity alloc] init];
    user.mobile = mobileField.text;
    user.password = passwordField.text;
    
    [self.delegate actionLogin:user];
}

- (void)actionFindPwd
{
    [self.delegate actionFindPwd];
}

@end
