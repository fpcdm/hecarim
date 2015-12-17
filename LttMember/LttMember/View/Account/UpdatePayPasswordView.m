//
//  UpdatePayPasswordView.m
//  LttMember
//
//  Created by 杨海锋 on 15/12/9.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "UpdatePayPasswordView.h"
#import "DLRadioButton.h"

@implementation UpdatePayPasswordView
{
    UITextField *oldPassword;
    UITextField *newPassword;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    int padding = 10;
    
    oldPassword = [AppUIUtil makeTextField];
    oldPassword.placeholder = @"输入原支付密码";
    oldPassword.font = FONT_MAIN;
    oldPassword.secureTextEntry = YES;
    oldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    oldPassword.keyboardType = UIKeyboardTypeNumberPad;
    oldPassword.textColor = COLOR_MAIN_BLACK;
    [self addSubview:oldPassword];
    
    [oldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@40);
    }];
    
    newPassword = [AppUIUtil makeTextField];
    newPassword.placeholder = @"输入新的支付密码";
    newPassword.font = FONT_MAIN;
    newPassword.secureTextEntry = YES;
    newPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPassword.keyboardType = UIKeyboardTypeNumberPad;
    newPassword.textColor = COLOR_MAIN_BLACK;
    [self addSubview:newPassword];
    
    [newPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldPassword.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@40);
    }];
    
    //显示密码
    DLRadioButton *radio = [[DLRadioButton alloc] init];
    radio.isIconSquare = YES;
    radio.iconSize = 16.0f;
    radio.titleLabel.font = FONT_MAIN;
    [radio addTarget:self action:@selector(actionShowPassword:) forControlEvents:UIControlEventTouchUpInside];
    [radio setTitle:@"显示密码" forState:UIControlStateNormal];
    [radio setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [self addSubview:radio];
    
    [radio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newPassword.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"下一步"];
    [button addTarget:self action:@selector(actionNext) forControlEvents:UIControlEventTouchUpInside];
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
    if (oldPassword.secureTextEntry) {
        radio.selected = YES;
        oldPassword.secureTextEntry = NO;
        newPassword.secureTextEntry = NO;
    } else {
        radio.selected = NO;
        oldPassword.secureTextEntry = YES;
        newPassword.secureTextEntry = YES;
    }
}

- (void)actionNext
{
    [self.delegate actionNext:oldPassword.text newPassword:newPassword.text];
}

@end
