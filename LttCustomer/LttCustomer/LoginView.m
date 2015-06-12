//
//  LoginView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/12.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIButton *button = [AppUIUtil makeButton:@"模拟"];
    [button addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIView *superview = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.centerX.equalTo(superview.mas_centerX);
        
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    return self;
}

- (void)actionLogin
{
    [self.delegate actionLogin];
}

@end
