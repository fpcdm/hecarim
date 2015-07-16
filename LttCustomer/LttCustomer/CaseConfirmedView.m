//
//  CaseConfirmedView.m
//  LttCustomer
//
//  Created by wuyong on 15/7/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseConfirmedView.h"
#import "CaseEntity.h"

@implementation CaseConfirmedView
{
    UIWebView *mapWebView;
    UIImageView *avatarView;
    UILabel *nameLabel;
    UIButton *mobileButton;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //地图视图
    mapWebView = [[UIWebView alloc] init];
    mapWebView.scrollView.bounces = NO;
    [self addSubview:mapWebView];
    
    UIView *superview = self;
    [mapWebView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom).offset(-100);
    }];
    
    //客服信息
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"正在为您服务的客服：";
    titleLabel.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
    titleLabel.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [self addSubview:titleLabel];
    
    int padding = 10;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(mapWebView.mas_bottom).offset(padding + 4);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@16);
    }];
    
    //头像
    avatarView = [[UIImageView alloc] init];
    [self addSubview:avatarView];
    
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(titleLabel.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    //姓名
    nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
    nameLabel.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [self addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(avatarView.mas_top).offset(5);
        make.left.equalTo(avatarView.mas_right).offset(padding);
        
        make.height.equalTo(@16);
    }];
    
    //电话
    mobileButton = [[UIButton alloc] init];
    [mobileButton setTitleColor:[UIColor colorWithHexString:COLOR_DARK_TEXT] forState:UIControlStateNormal];
    mobileButton.titleLabel.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    [self addSubview:mobileButton];
    
    [mobileButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(avatarView.mas_right).offset(padding);
        make.bottom.equalTo(avatarView.mas_bottom).offset(-5);
        
        make.height.equalTo(@16);
    }];
    
    //投诉
    UIButton *complainButton = [[UIButton alloc] init];
    [complainButton setTitleColor:[UIColor colorWithHexString:COLOR_DARK_TEXT] forState:UIControlStateNormal];
    [complainButton addTarget:self action:@selector(actionComplain) forControlEvents:UIControlEventTouchUpInside];
    complainButton.titleLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [self addSubview:complainButton];
    //文字下划线
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"我要投诉"];
    NSRange strRange = {0, [str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [complainButton setAttributedTitle:str forState:UIControlStateNormal];
    
    [complainButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.bottom.equalTo(superview.mas_bottom).offset(-15);
        
        make.height.equalTo(@16);
    }];
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    CaseEntity *intention = [self getData:@"intention"];
    
    //加载地图
    NSURL *url =[NSURL URLWithString:intention.mapUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [mapWebView loadRequest:request];
    
    //客服信息
    [intention avatarView:avatarView];
    nameLabel.text = intention.employeeName;
    [mobileButton setTitle:intention.employeeMobile forState:UIControlStateNormal];
    [mobileButton addTarget:self action:@selector(actionMobile) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action
- (void) actionMobile
{
    [self.delegate actionMobile];
}

- (void) actionComplain
{
    [self.delegate actionComplain];
}

@end
