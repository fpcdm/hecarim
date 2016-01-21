//
//  SetPayPasswordCodeView.m
//  LttMember
//
//  Created by 杨海锋 on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "SetPayPasswordCodeView.h"

@implementation SetPayPasswordCodeView
{
    UITextField *codeInput;
}

@synthesize sendBtn;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    return self;
}

- (void)display
{
    UIView *superView = self;
    int padding = 10;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = FONT_MIDDLE;
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@20);
    }];
    
    UserEntity *userEntity = [self fetch:@"user"];
    NSString *mobile = userEntity.mobile;
    NSMutableString *mobileStr = [[NSMutableString alloc] initWithString:mobile];
    [mobileStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    NSString *tipStr = [NSString stringWithFormat:@"请输入手机号%@收到的短信验证码.",mobileStr];
    NSMutableAttributedString *tipAttr = [[NSMutableAttributedString alloc] initWithString:tipStr];
    [tipAttr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 11)];
    tipLabel.attributedText = tipAttr;
    
    sendBtn = [[UIButton alloc] init];
    sendBtn.layer.borderWidth = 0.5f;
    sendBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    sendBtn.layer.cornerRadius = 3.0f;
    sendBtn.titleLabel.font = FONT_MAIN;
    sendBtn.backgroundColor = COLOR_MAIN_WHITE;
    [sendBtn addTarget:self action:@selector(actionSendSms) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送短信" forState:UIControlStateNormal];
    [sendBtn setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [self addSubview:sendBtn];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    
    codeInput = [[UITextField alloc] init];
    codeInput.layer.borderWidth = 0.5f;
    codeInput.layer.borderColor = CGCOLOR_MAIN_BORDER;
    codeInput.layer.cornerRadius = 3.0f;
    codeInput.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    codeInput.placeholder = @"请输入短信中的验证码";
    codeInput.font = FONT_MAIN;
    codeInput.keyboardType = UIKeyboardTypeNumberPad;
    codeInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置内左边距
    CGRect frame = [codeInput frame];
    frame.size.width = 5.0f;
    UIView *leftView = [[UIView alloc] initWithFrame:frame];
    codeInput.leftViewMode = UITextFieldViewModeAlways;
    codeInput.leftView = leftView;
    [self addSubview:codeInput];
    
    [codeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(sendBtn.mas_left).offset(-padding);
        make.height.equalTo(@40);
    }];
    
    UIButton *button = [AppUIUtil makeButton:@"验证"];
    [button addTarget:self action:@selector(actionVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeInput.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
}

- (void)actionSendSms
{
    [self.delegate actionSendSms];
}

- (void)actionVerifyCode
{
    [self.delegate actionVerifyCode:codeInput.text];
}
@end
