//
//  LoginView.m
//  LttCustomer
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
    
    //修正闪烁
    self.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    
    //输入框
    mobileField = [AppUIUtil makeTextField];
    mobileField.keyboardType = UIKeyboardTypeNumberPad;
    mobileField.placeholder = @"手机号";
    [self addSubview:mobileField];
    
    UIView *superview = self;
    int padding = 10;
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@40);
    }];
    
    //密码
    passwordField = [AppUIUtil makeTextField];
    passwordField.placeholder = @"密码";
    passwordField.secureTextEntry = YES;
    [self addSubview:passwordField];
    
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(mobileField.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@40);
    }];
    
    //按钮
    button = [AppUIUtil makeButton:@"登陆"];
    [button addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(passwordField.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
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

@end
