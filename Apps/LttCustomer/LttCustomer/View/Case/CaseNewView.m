//
//  IntentionNewView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseNewView.h"

@implementation CaseNewView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UILabel *bigLabel = [UILabel new];
    bigLabel.text = @"收到";
    bigLabel.backgroundColor = [UIColor clearColor];
    bigLabel.font = [UIFont boldSystemFontOfSize:26];
    bigLabel.textColor = COLOR_MAIN_HIGHLIGHT;
    [self addSubview:bigLabel];
    
    UIView *superview = self;
    [bigLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(40);
        make.centerX.equalTo(superview.mas_centerX);
        
    }];
    
    UILabel *textLabel = [UILabel new];
    textLabel.text = @"正在为您呼叫客服";
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont boldSystemFontOfSize:16];
    textLabel.textColor = COLOR_MAIN_GRAY;
    [self addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bigLabel.mas_bottom).offset(10);
        make.centerX.equalTo(superview.mas_centerX);
        
    }];
    
    //定时器
    UILabel *timerLabel = [UILabel new];
    timerLabel.text = @"00:00";
    timerLabel.backgroundColor = [UIColor clearColor];
    timerLabel.font = [UIFont boldSystemFontOfSize:16];
    timerLabel.textColor = COLOR_MAIN_HIGHLIGHT;
    [self addSubview:timerLabel];
    self.timerLabel = timerLabel;
    
    [timerLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(textLabel.mas_bottom).offset(20);
        make.centerX.equalTo(superview.mas_centerX);
    }];
    
    //取消呼叫
    UIButton *cancelButton = [UIButton new];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    cancelButton.titleLabel.backgroundColor = [UIColor clearColor];
    [cancelButton setTitle:@"取消呼叫" forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR_MAIN_GRAY forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom).offset(-10);
        make.centerX.equalTo(superview.mas_centerX);
    }];
    
    return self;
}

#pragma mark - Action
- (void)actionCancel
{
    [self.delegate actionCancel];
}

@end
