//
//  RegisterCodeView.m
//  LttCustomer
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "RegisterCodeView.h"

@implementation RegisterCodeView
{
    UILabel *tipLabel;
    UITextField *codeField;
}

@synthesize sendButton;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //提示标题
    tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [self addSubview:tipLabel];
    
    UIView *superview = self;
    int padding = 10;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.centerX.equalTo(superview.mas_centerX);
    }];
    
    //发送按钮
    sendButton = [[UIButton alloc] init];
    [sendButton setTitle:@"重新获取" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_TEXT] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(actionSend) forControlEvents:UIControlEventTouchUpInside];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    sendButton.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    sendButton.layer.borderColor = [UIColor colorWithHexString:COLOR_MAIN_BORDER].CGColor;
    sendButton.layer.borderWidth = 0.5f;
    sendButton.layer.cornerRadius = 3.0f;
    [self addSubview:sendButton];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.top.equalTo(tipLabel.mas_bottom).offset(padding + 7);
        
        make.height.equalTo(@35);
        make.width.equalTo(@100);
    }];
    
    //输入视图
    UIView *inputView = [UIView new];
    inputView.layer.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG].CGColor;
    inputView.layer.borderColor = [UIColor colorWithHexString:COLOR_MAIN_BORDER].CGColor;
    inputView.layer.cornerRadius = 3.0f;
    inputView.layer.borderWidth = 0.5f;
    [self addSubview:inputView];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipLabel.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(sendButton.mas_left).offset(-padding);
        
        make.height.equalTo(@50);
    }];
    
    //效验码
    UILabel *codeLabel = [UILabel new];
    codeLabel.text = @"效验码";
    codeLabel.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [inputView addSubview:codeLabel];
    
    superview = inputView;
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(padding);
        make.top.equalTo(superview.mas_top).offset(padding);
        
        make.height.equalTo(@30);
        make.width.equalTo(@50);
    }];
    
    //验证码输入框
    codeField = [AppUIUtil makeTextField];
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.placeholder = @"短信效验码";
    codeField.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [inputView addSubview:codeField];
    
    [codeField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(codeLabel.mas_right);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@30);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"下一步"];
    [button addTarget:self action:@selector(actionVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    superview = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(inputView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    //注册协议
    UILabel *protocolIntro = [[UILabel alloc] init];
    protocolIntro.text = @"注册即视为同意";
    protocolIntro.textColor = [UIColor colorWithHexString:COLOR_GRAY_TEXT];
    protocolIntro.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [self addSubview:protocolIntro];
    
    [protocolIntro mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(button.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
    }];
    
    UILabel *protocolTitle = [[UILabel alloc] init];
    protocolTitle.text = @"两条腿平台服务协议。";
    protocolTitle.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
    protocolTitle.font = [UIFont boldSystemFontOfSize:SIZE_MAIN_TEXT];
    [self addSubview:protocolTitle];
    
    [protocolTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(protocolIntro.mas_centerY);
        make.left.equalTo(protocolIntro.mas_right).offset(3);
    }];
    
    return self;
}

- (void) renderData
{
    NSString *mobile = [self getData:@"mobile"];
    tipLabel.text = [NSString stringWithFormat:@"请输入手机号%@收到的短信效验码", mobile];
}

#pragma mark - Action
- (void)actionSend
{
    [self.delegate actionSend];
}

- (void)actionVerifyCode
{
    [self.delegate actionVerifyCode:codeField.text];
}

@end
