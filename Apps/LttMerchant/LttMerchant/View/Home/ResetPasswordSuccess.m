//
//  ResetPasswordSuccess.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/10/21.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "ResetPasswordSuccess.h"
#import "AppUIUtil.h"

@implementation ResetPasswordSuccess
{
    UILabel *tipLabel;
    UIButton *button;
}

- (id)init
{
    self  = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    
    //提示信息
    tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"您的密码已经重置成功";
    tipLabel.font = [UIFont systemFontOfSize:20];
    tipLabel.textColor = [UIColor blackColor];
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(30);
        make.centerX.equalTo(superView.mas_centerX);
    }];
    
    button = [AppUIUtil makeButton:@"重新登录"];
    [button addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
        make.left.equalTo(superView.mas_left).offset(10);
        make.right.equalTo(superView.mas_right).offset(-10);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    return self;
}

- (void)actionLogin
{
    [self.delegate actionLogin];
}

@end
