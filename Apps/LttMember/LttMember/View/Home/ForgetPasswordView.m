//
//  ForgetPasswordView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/10/19.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "ForgetPasswordView.h"
#import "AppUIUtil.h"

@implementation ForgetPasswordView
{
    UITextField *mobileField;
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
    
    UIView *superView = self;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(20);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@50);
    }];
    
    //手机号
    UILabel *labelName = [[UILabel alloc] init];
    labelName.text = @"手机号";
    labelName.font = FONT_MAIN;
    [self addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputView.mas_centerY);
        make.left.equalTo(superView.mas_left).offset(10);
        make.width.equalTo(@50);
    }];
    
    //输入框
    mobileField = [AppUIUtil makeTextField];
    mobileField.placeholder = @"请输入手机号";
    mobileField.font = FONT_MAIN;
    //定义编辑时显示清除按钮效果
    mobileField.clearButtonMode = YES;
    //设置为数字键盘
    mobileField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:mobileField];
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputView.mas_centerY);
        make.left.equalTo(labelName.mas_right);
        make.right.equalTo(inputView.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"下一步"];
    [button addTarget:self action:@selector(actionNext) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    superView = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(inputView.mas_bottom).offset(10);
        make.left.equalTo(superView.mas_left).offset(10);
        make.right.equalTo(superView.mas_right).offset(-10);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];


    
    return self;
}

- (void) display
{
    NSString *mobile = [self fetch:@"mobile"];
    mobileField.text = mobile;
}

#pragma mark - Action
- (void)actionNext
{
    [self.delegate actionCheckMobile:mobileField.text];
}



@end

