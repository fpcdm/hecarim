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
    UIButton *staffBtn;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    
    UIButton *serviceBtn = [[UIButton alloc] init];
    serviceBtn.layer.borderWidth = 0.5f;
    serviceBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    serviceBtn.backgroundColor = COLOR_MAIN_WHITE;
    serviceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [serviceBtn addTarget:self action:@selector(actionCaseList) forControlEvents:UIControlEventTouchUpInside];
    [serviceBtn setTitle:@"服务单管理" forState:UIControlStateNormal];
    [serviceBtn setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [self addSubview:serviceBtn];
    
    [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(20);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@50);
    }];
    
    staffBtn = [[UIButton alloc] init];
    staffBtn.hidden = YES;
    staffBtn.layer.borderWidth = 0.5f;
    staffBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    staffBtn.backgroundColor = COLOR_MAIN_WHITE;
    staffBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [staffBtn addTarget:self action:@selector(actionStaff) forControlEvents:UIControlEventTouchUpInside];
    [staffBtn setTitle:@"人员管理" forState:UIControlStateNormal];
    [staffBtn setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [self addSubview:staffBtn];
    
    [staffBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceBtn.mas_bottom).offset(10);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@50);
    }];
    
    return self;
}

- (void)renderData
{
    NSNumber *is_admin = [self getData:@"is_admin"];
    if ([@1 isEqualToNumber:is_admin]) {
        staffBtn.hidden = NO;
    }
}

- (void)actionCaseList
{
    [self.delegate actionCaseList];
}

- (void)actionStaff
{
    [self.delegate actionStaff];
}

@end
