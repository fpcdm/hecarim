//
//  RegisterPasswordView.m
//  LttMember
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "RegisterPasswordView.h"

@implementation RegisterPasswordView
{
    UITextField *passwordField;
    UITextField *confirmField;
    UIView *superview;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    superview = self;
    int padding = 10;
    
    //输入视图
    UIView *inputView = [UIView new];
    inputView.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    inputView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    inputView.layer.cornerRadius = 3.0f;
    inputView.layer.borderWidth = 0.5f;
    [self addSubview:inputView];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    
    //帐号密码
    UILabel *passwordLabel = [UILabel new];
    passwordLabel.text = @"密码";
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.font = FONT_MAIN;
    [inputView addSubview:passwordLabel];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(inputView.mas_left).offset(padding);
        make.top.equalTo(inputView.mas_top).offset(padding);
        make.height.equalTo(@30);
        make.width.equalTo(@67);
    }];
    
    //密码输入框
    passwordField = [AppUIUtil makeTextField];
    passwordField.placeholder = @"请输入帐号密码";
    passwordField.secureTextEntry = YES;
    passwordField.font = FONT_MAIN;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputView addSubview:passwordField];
    
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(inputView.mas_top).offset(padding);
        make.left.equalTo(passwordLabel.mas_right);
        make.right.equalTo(inputView.mas_right);
        make.height.equalTo(@30);
    }];
    
    //确认密码视图
    UIView *confirmView = [[UIView alloc] init];
    confirmView.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    confirmView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    confirmView.layer.cornerRadius = 3.0f;
    confirmView.layer.borderWidth = 0.5f;
    [self addSubview:confirmView];
    
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(inputView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    
    //密码确认
    UILabel *confirmLabel = [[UILabel alloc] init];
    confirmLabel.text = @"密码确认";
    confirmLabel.backgroundColor = [UIColor clearColor];
    confirmLabel.font = FONT_MAIN;
    [confirmView addSubview:confirmLabel];
    
    [confirmLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(confirmView.mas_left).offset(padding);
        make.top.equalTo(confirmView.mas_top).offset(padding);
        make.height.equalTo(@30);
        make.width.equalTo(@67);
    }];
    
    //密码确认输入框
    confirmField = [AppUIUtil makeTextField];
    confirmField.placeholder = @"请输入帐号密码";
    confirmField.secureTextEntry = YES;
    confirmField.font = FONT_MAIN;
    confirmField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [confirmView addSubview:confirmField];
    
    [confirmField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(confirmView.mas_top).offset(padding);
        make.left.equalTo(confirmLabel.mas_right);
        make.right.equalTo(confirmView.mas_right);
        make.height.equalTo(@30);
    }];
    
    //密码提示
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"密码由6-20位英文字母，数字或符号组成";
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = FONT_MIDDLE;
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(confirmView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"下一步"];
    [button addTarget:self action:@selector(actionSendPassword) forControlEvents:UIControlEventTouchUpInside];
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
- (void) actionSendPassword
{
    [self.delegate actionSendPassword:passwordField.text confirmPwd:confirmField.text];
}
@end
