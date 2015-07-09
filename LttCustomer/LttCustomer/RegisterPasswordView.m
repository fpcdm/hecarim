//
//  RegisterPasswordView.m
//  LttCustomer
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "RegisterPasswordView.h"

@implementation RegisterPasswordView
{
    UITextField *passwordField;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //输入视图
    UIView *inputView = [UIView new];
    inputView.layer.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG].CGColor;
    inputView.layer.borderColor = [UIColor colorWithHexString:COLOR_MAIN_BORDER].CGColor;
    inputView.layer.cornerRadius = 3.0f;
    inputView.layer.borderWidth = 0.5f;
    [self addSubview:inputView];
    
    UIView *superview = self;
    int padding = 10;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@50);
    }];
    
    //登陆密码
    UILabel *passwordLabel = [UILabel new];
    passwordLabel.text = @"登陆密码";
    passwordLabel.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [inputView addSubview:passwordLabel];
    
    superview = inputView;
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(padding);
        make.top.equalTo(superview.mas_top).offset(padding);
        
        make.height.equalTo(@30);
        make.width.equalTo(@67);
    }];
    
    //密码输入框
    passwordField = [AppUIUtil makeTextField];
    passwordField.placeholder = @"请输入密码";
    passwordField.secureTextEntry = YES;
    passwordField.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [inputView addSubview:passwordField];
    
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(passwordLabel.mas_right);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@30);
    }];
    
    //密码提示
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"密码由6-20位英文字母，数字或符号组成";
    tipLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [self addSubview:tipLabel];
    
    superview = self;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(inputView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"确定"];
    [button addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipLabel.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    return self;
}

#pragma mark - Action
- (void) actionRegister
{
    [self.delegate actionRegister:passwordField.text];
}

@end
