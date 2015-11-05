//
//  HomeView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/2.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "HomeView.h"

@implementation HomeView
{
    UILabel *tipLabel;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    
    //视图
    UIView *uiView = [UIView new];
    uiView.backgroundColor = COLOR_MAIN_WHITE;
    uiView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    uiView.layer.borderWidth = 0.5f;
    [self addSubview:uiView];
    
    [uiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(20);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@50);
        
    }];
    
    UIButton *serviceBtn = [[UIButton alloc] init];
    serviceBtn.layer.borderWidth = 0.0f;
    serviceBtn.layer.borderColor = [UIColor clearColor].CGColor;
    serviceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [serviceBtn addTarget:self action:@selector(actionCaseList) forControlEvents:UIControlEventTouchUpInside];
    [serviceBtn setTitle:@"服务单管理" forState:UIControlStateNormal];
    [serviceBtn setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [uiView addSubview:serviceBtn];
    
    [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(uiView.mas_centerX);
        make.centerY.equalTo(uiView.mas_centerY);
        make.left.equalTo(uiView.mas_left);
        make.right.equalTo(uiView.mas_right);
    }];
    return self;
}

- (void)actionCaseList
{
    [self.delegate actionCaseList];
}

@end
