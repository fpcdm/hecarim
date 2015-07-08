//
//  RegisterMobileView.m
//  LttCustomer
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "RegisterMobileView.h"

@implementation RegisterMobileView
{
    UITextField *mobileField;
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
        make.top.equalTo(superview.mas_top).offset(20);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@50);
    }];
    
    //手机号
    UILabel *mobileLabel = [UILabel new];
    mobileLabel.text = @"手机号";
    mobileLabel.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [inputView addSubview:mobileLabel];
    
    superview = inputView;
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(padding);
        make.top.equalTo(superview.mas_top).offset(padding);
        
        make.height.equalTo(@30);
        make.width.equalTo(@50);
    }];
    
    //手机号输入框
    mobileField = [AppUIUtil makeTextField];
    mobileField.keyboardType = UIKeyboardTypePhonePad;
    mobileField.placeholder = @"请输入手机号码";
    mobileField.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [inputView addSubview:mobileField];
    
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(mobileLabel.mas_right);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@30);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"下一步"];
    [button addTarget:self action:@selector(actionNext) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Action
- (void)actionNext
{
    [self.delegate actionCheckMobile:mobileField.text];
}

@end
