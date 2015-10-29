//
//  RegisterSuccessView.m
//  LttMember
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "RegisterSuccessView.h"

@implementation RegisterSuccessView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"registerSuccess"];
    [self addSubview:imageView];
    
    UIView *superview = self;
    int padding = 10;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(70);
        make.centerX.equalTo(superview.mas_centerX);
        
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    //注册成功
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.font = FONT_MAIN;
    successLabel.text = @"恭喜您注册成为两条腿商户！";
    successLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:successLabel];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(imageView.mas_bottom).offset(padding);
        make.centerX.equalTo(superview.mas_centerX);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"您的请求已经受理，\n我们将尽快审核您的商户申请。";
    tipLabel.font = FONT_MAIN;
    tipLabel.textColor = [UIColor redColor];
    tipLabel.numberOfLines = 2;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLabel.mas_bottom).offset(padding);
        make.centerX.equalTo(superview.mas_centerX);
//        make.height.equalTo(@16);
    }];

    
    //返回首页
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"返回首页" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionHome) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = FONT_MAIN;
    button.titleLabel.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = 3.0f;
    button.layer.borderColor = CGCOLOR_MAIN_BORDER;
    button.layer.borderWidth = 0.5f;
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipLabel.mas_bottom).offset(padding);
        make.centerX.equalTo(superview.mas_centerX);
        
        make.width.equalTo(@120);
        make.height.equalTo(@35);
    }];
    
    return self;
}

- (void)actionHome
{
    [self.delegate actionLogin];
}

@end
