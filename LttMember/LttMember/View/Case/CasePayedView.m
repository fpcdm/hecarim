//
//  CasePayedView.m
//  LttMember
//
//  Created by wuyong on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CasePayedView.h"

@implementation CasePayedView

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    //确认支付完成
    UIButton *confirmButton = [AppUIUtil makeButton:@"支付完成"];
    [confirmButton addTarget:self action:@selector(actionConfirmPayed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    
    UIView *superview = self;
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(20);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@(HEIGHT_MAIN_BUTTON));
    }];
    
    //选择其他支付方式
    UIButton *chooseButton = [AppUIUtil makeButton:@"选择其它支付方式"];
    chooseButton.backgroundColor = COLOR_MAIN_WHITE;
    [chooseButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    chooseButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    chooseButton.layer.borderWidth = 0.5f;
    [chooseButton addTarget:self action:@selector(actionRechooseMethod) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chooseButton];
    
    [chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmButton.mas_bottom).offset(20);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@(HEIGHT_MAIN_BUTTON));
    }];
    
    return self;
}

- (void)renderData
{
    //无需任何操作
}

#pragma mark - Action
- (void)actionConfirmPayed
{
    [self.delegate actionConfirmPayed];
}

- (void)actionRechooseMethod
{
    [self.delegate actionRechooseMethod];
}

@end
