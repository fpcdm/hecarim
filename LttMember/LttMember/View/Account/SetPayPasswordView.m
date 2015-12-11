//
//  SetPayPasswordView.m
//  LttMember
//
//  Created by 杨海锋 on 15/12/9.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "SetPayPasswordView.h"
#import "DLRadioButton.h"

@implementation SetPayPasswordView
{
    UITextField *passwordField;
    UITextField *rePasswordField;
}

- (id)init
{
    UIView *superView = self;
    int padding = 10;
    
    self = [super init];
    if (!self) return nil;
    
    passwordField = [AppUIUtil makeTextField];
    passwordField.placeholder = @"输入一次密码";
    passwordField.textColor = COLOR_MAIN_BLACK;
    passwordField.layer.borderColor = CGCOLOR_MAIN_BORDER;
    passwordField.font = FONT_MAIN;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.secureTextEntry = YES;
    [self addSubview:passwordField];
    
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@40);
    }];
    
    rePasswordField = [AppUIUtil makeTextField];
    rePasswordField.placeholder = @"再输入一次密码";
    rePasswordField.textColor = COLOR_MAIN_BLACK;
    rePasswordField.layer.borderColor = CGCOLOR_MAIN_BORDER;
    rePasswordField.font = FONT_MAIN;
    rePasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    rePasswordField.secureTextEntry = YES;
    [self addSubview:rePasswordField];
    
    [rePasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordField.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@40);
    }];
    
    DLRadioButton *radio = [[DLRadioButton alloc] init];
    radio.isIconSquare = YES;
    radio.iconSize = 16.0f;
    radio.titleLabel.font = FONT_MAIN;
    [radio addTarget:self action:@selector(actionShowPassword:) forControlEvents:UIControlEventTouchUpInside];
    [radio setTitle:@"显示密码" forState:UIControlStateNormal];
    [radio setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [self addSubview:radio];
    
    [radio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rePasswordField.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    UIButton *button = [AppUIUtil makeButton:@"确定"];
    [button addTarget:self action:@selector(actionSetPayPassword) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(radio.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    return self;
}

- (void)actionShowPassword:(DLRadioButton *)radio
{
    if (passwordField.secureTextEntry) {
        radio.selected = YES;
        passwordField.secureTextEntry = NO;
        rePasswordField.secureTextEntry = NO;
    } else {
        radio.selected = NO;
        passwordField.secureTextEntry = YES;
        rePasswordField.secureTextEntry = YES;
    }
}

- (void)actionSetPayPassword
{
    [self.delegate actionSetPayPassword:passwordField.text rePassword:rePasswordField.text];
}

@end
