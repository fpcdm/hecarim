//
//  HomeView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeView.h"

@implementation HomeView
{
    UILabel *addressLabel;
    UILabel *infoLabel;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //背景颜色
    self.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG];
    
    //顶部
    [self topView];
    
    
    return self;
}

- (void) topView
{
    //顶部视图
    UIView *topView = [[UIView alloc] init];
    topView.layer.backgroundColor = [UIColor colorWithHexString:COLOR_HIGHLIGHTED_BG].CGColor;
    [self addSubview:topView];
    
    UIView *superview = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo(superview.mas_height).multipliedBy(0.35);
    }];
    
    //地址视图
    UIView *addressView = [[UIView alloc] init];
    addressView.layer.cornerRadius = 3.0f;
    addressView.layer.backgroundColor = [UIColor colorWithHexString:@"CE2D2F"].CGColor;
    [topView addSubview:addressView];
    
    superview = topView;
    [addressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(15);
        make.left.equalTo(superview.mas_left).offset(30);
        make.right.equalTo(superview.mas_right).offset(-30);
        
        make.height.equalTo(@50);
    }];
    
    //地址标签
    addressLabel = [[UILabel alloc] init];
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.font = [UIFont boldSystemFontOfSize:SIZE_MAIN_TEXT];
    [addressView addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(addressView.mas_top).offset(5);
        make.left.equalTo(addressView.mas_left).offset(10);
    }];
    
    //信息标签
    infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont boldSystemFontOfSize:SIZE_SMALL_TEXT];
    [addressView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(addressLabel.mas_bottom).offset(5);
        make.left.equalTo(addressView.mas_left).offset(10);
    }];
    
    //开始视图
    UIView *beginView = [[UIView alloc] init];
    beginView.layer.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG].CGColor;
    beginView.layer.cornerRadius = 3.0f;
    [topView addSubview:beginView];
    
    [beginView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(20);
        make.bottom.equalTo(superview.mas_bottom).offset(3.0f);
        
        make.width.equalTo(@85);
        make.height.equalTo(@28);
    }];
    
    //开始文字
    UILabel *beginLabel = [[UILabel alloc] init];
    beginLabel.text = @"我们开始吧!";
    beginLabel.font = [UIFont boldSystemFontOfSize:10];
    beginLabel.textAlignment = NSTextAlignmentCenter;
    beginLabel.textColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_HIGHLIGHTED];
    [beginView addSubview:beginLabel];
    
    [beginLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(beginView.mas_top);
        make.bottom.equalTo(beginView.mas_bottom);
        make.left.equalTo(beginView.mas_left);
        make.right.equalTo(beginView.mas_right);
    }];
}

#pragma mark - RenderData
- (void) renderData
{
    NSString *address = [self getData:@"address"];
    NSNumber *count = [self getData:@"count"];
    
    addressLabel.text = address;
    infoLabel.text = [NSString stringWithFormat:@"有%@个信使等待为您服务", count ? count : @0];
    
}

@end
