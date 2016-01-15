//
//  ResetPasswordView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/10/21.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "ResetPasswordView.h"
#import "AppUIUtil.h"
#import "DLRadioButton.h"

@implementation ResetPasswordView
{
    UITextField *passwordField;
    UITextField *rePasswordField;
    DLRadioButton *radioButton;
    UIButton *button;
    UILabel *tipLabel;
}


- (id)init
{
    self  = [super init];
    if (!self) return nil;
    
    //新密码输入框
    passwordField = [AppUIUtil makeTextField];
    passwordField.placeholder = @"请输入新密码";
    passwordField.font = FONT_MAIN;
    passwordField.secureTextEntry = YES;
    passwordField.clearButtonMode = YES;
    passwordField.layer.borderWidth = 0.5f;
    passwordField.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [self addSubview:passwordField];
    
    UIView *superView = self;
    int padding = 10;
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    
    //请确认新密码
    rePasswordField = [AppUIUtil makeTextField];
    rePasswordField.placeholder = @"请确认新密码";
    rePasswordField.font = FONT_MAIN;
    rePasswordField.secureTextEntry = YES;
    rePasswordField.clearButtonMode = YES;
    rePasswordField.layer.borderWidth = 0.5f;
    rePasswordField.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [self addSubview:rePasswordField];
    
    [rePasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordField.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    
    //密码长度提示
    tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"密码由6-15位英文字母，数字组成";
    tipLabel.font = FONT_MAIN;
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rePasswordField.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
    }];
    
    
    //单选按钮
    radioButton = [[DLRadioButton alloc] init];
    radioButton.titleLabel.font = FONT_MAIN;
    radioButton.iconColor = [UIColor blackColor];
    radioButton.indicatorColor = [UIColor blackColor];
    radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [radioButton addTarget:self action:@selector(actionRadioClicked:) forControlEvents:UIControlEventTouchUpInside];
    [radioButton setTitle:@"显示密码" forState:UIControlStateNormal];
    [radioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    radioButton.isIconSquare = YES;
    [self addSubview:radioButton];
    
    [radioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
    }];

    //按钮
    button = [AppUIUtil makeButton:@"下一步"];
    [button addTarget:self action:@selector(actionResetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(radioButton.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MAIN_BUTTON]);
    }];
    return self;
}

//显示密码事件
#pragma mark - Radio
- (void)actionRadioClicked:(DLRadioButton *)radio
{
    if (passwordField.secureTextEntry == YES) {
        passwordField.secureTextEntry = NO;
        rePasswordField.secureTextEntry = NO;
        radio.selected = YES;
    } else {
        passwordField.secureTextEntry = YES;
        rePasswordField.secureTextEntry = YES;
        radio.selected = NO;
    }
}

- (void)actionResetPassword
{
    NSString *password = passwordField.text;
    NSString *rePassword = rePasswordField.text;
    [self.delegate actionResetPassword:password reNewPassword:rePassword];
}

@end
