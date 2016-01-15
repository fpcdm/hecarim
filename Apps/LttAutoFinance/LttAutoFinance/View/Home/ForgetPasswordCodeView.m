//
//  ForgetPasswordMsgView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/10/20.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "ForgetPasswordCodeView.h"
#import "AppUIUtil.h"

@implementation ForgetPasswordCodeView
{
    UILabel *tipLabel;
    UITextField *codeField;
    UILabel *tipMobile;
}

@synthesize sendButton;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    
    //提示
    tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"我们已经发送校验码到您的手机：";
    tipLabel.font = FONT_MAIN;
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(10);
        make.left.equalTo(superView.mas_left).offset(10);
        make.right.equalTo(superView.mas_right).offset(10);
        make.height.equalTo(@16);
    }];
    
    //手机号
    tipMobile = [[UILabel alloc] init];
    tipMobile.font = FONT_MAIN;
    [self addSubview:tipMobile];
    
    [tipMobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
        make.centerX.equalTo(superView.mas_centerX);
        make.height.equalTo(@16);
    }];
    
    //输入视图
    UIView *inputView = [UIView new];
    inputView.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    inputView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    inputView.layer.borderWidth = 0.5f;
    [self addSubview:inputView];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipMobile.mas_bottom).offset(10);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@50);
    }];
    
    //输入框名称
    UILabel *inputLabel = [[UILabel alloc] init];
    inputLabel.text = @"校验码";
    inputLabel.font = FONT_MAIN;
    [inputView addSubview:inputLabel];
    
    [inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputView.mas_left).offset(10);
        make.centerY.equalTo(inputView.mas_centerY);
        make.width.equalTo(@50);
    }];
    
    //校验码输入框
    codeField = [AppUIUtil makeTextField];
    codeField.placeholder = @"请输入校验码";
    codeField.font = FONT_MAIN;
    codeField.clearButtonMode = YES;
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    [inputView addSubview:codeField];
    
    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.equalTo(codeField.mas_right);
        make.height.equalTo(@25);
        make.width.equalTo(@1);
    }];
    
    //发送短信按钮
    sendButton = [[UIButton alloc] init];
    [sendButton setTitle:@"发送短信" forState:UIControlStateNormal];
    [sendButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(actionSend) forControlEvents:UIControlEventTouchUpInside];
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
    
    //下一步按钮
    UIButton *button = [AppUIUtil makeButton:@"下一步"];
    [button addTarget:self action:@selector(actionVerifyCode) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark - Action
- (void)actionSend
{
    [self.delegate actionSend];
}

//校验码验证
- (void)actionVerifyCode
{
    [self.delegate actionVerifyCode:codeField.text];
}

- (void)renderData
{
    NSString *mobile = [self getData:@"mobile"];
    NSMutableString *strMobile = [[NSMutableString alloc] initWithString:mobile];
    [strMobile replaceCharactersInRange:NSMakeRange(3,5) withString:@"*****"];
    tipMobile.text = strMobile;
}


@end
