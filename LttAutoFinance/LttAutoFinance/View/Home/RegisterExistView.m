//
//  RegisterExistView.m
//  LttAutoFInance
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "RegisterExistView.h"

@implementation RegisterExistView
{
    UILabel *mobileLabel;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"registerExist"];
    [self addSubview:imageView];
    
    UIView *superview = self;
    int padding = 10;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(70);
        make.centerX.equalTo(superview.mas_centerX);
        
        make.width.equalTo(@48);
        make.height.equalTo(@48);
    }];
    
    //手机号
    mobileLabel = [[UILabel alloc] init];
    mobileLabel.backgroundColor = [UIColor clearColor];
    mobileLabel.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [self addSubview:mobileLabel];
    
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(imageView.mas_bottom).offset(padding);
        make.centerX.equalTo(superview.mas_centerX);
    }];
    
    //已注册
    UILabel *registeredLabel = [[UILabel alloc] init];
    registeredLabel.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    registeredLabel.backgroundColor = [UIColor clearColor];
    registeredLabel.text = @"当前手机号已注册，你看可以";
    [self addSubview:registeredLabel];
    
    [registeredLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(mobileLabel.mas_bottom).offset(padding);
        make.centerX.equalTo(superview.mas_centerX).offset(-35);
    }];
    
    //直接登陆
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"直接登陆" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_BUTTON_BG] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    button.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(registeredLabel.mas_right);
        make.centerY.equalTo(registeredLabel.mas_centerY);
        
        make.width.equalTo(@70);
    }];
    
    return self;
}

- (void) renderData
{
    NSString *mobile = [self getData:@"mobile"];
    mobileLabel.text = mobile;
}

#pragma mark - Action
- (void) actionLogin
{
    [self.delegate actionLogin];
}

@end
