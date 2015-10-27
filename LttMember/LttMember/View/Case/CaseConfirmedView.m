//
//  CaseConfirmedView.m
//  LttMember
//
//  Created by wuyong on 15/7/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseConfirmedView.h"
#import "CaseEntity.h"

@interface CaseConfirmedView () <UIWebViewDelegate>

@end

@implementation CaseConfirmedView
{
    UIWebView *mapWebView;
    UIImageView *avatarView;
    UILabel *nameLabel;
    UIButton *mobileButton;
    
    UIActivityIndicatorView *indicatorView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //地图视图
    mapWebView = [[UIWebView alloc] init];
    mapWebView.scrollView.bounces = NO;
    mapWebView.backgroundColor = COLOR_MAIN_WHITE;
    mapWebView.opaque = NO;
    mapWebView.delegate = self;
    [self addSubview:mapWebView];
    
    UIView *superview = self;
    [mapWebView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom).offset(-100);
    }];
    
    //加载中
    indicatorView = [[UIActivityIndicatorView alloc] init];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addSubview:indicatorView];
    
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(mapWebView.mas_centerX);
        make.centerY.equalTo(mapWebView.mas_centerY);
        
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    //客服信息
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"正在为您服务的服务商：";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR_MAIN_DARK;
    titleLabel.font = FONT_MAIN;
    [self addSubview:titleLabel];
    
    int padding = 10;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(mapWebView.mas_bottom).offset(padding + 4);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@16);
    }];
    
    //头像
    avatarView = [[UIImageView alloc] init];
    avatarView.layer.cornerRadius = 25;
    [self addSubview:avatarView];
    
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(titleLabel.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    //姓名
    nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = COLOR_MAIN_DARK;
    nameLabel.font = FONT_MAIN;
    [self addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(avatarView.mas_top).offset(5);
        make.left.equalTo(avatarView.mas_right).offset(padding);
        
        make.height.equalTo(@16);
    }];
    
    //电话
    mobileButton = [[UIButton alloc] init];
    [mobileButton setTitleColor:COLOR_MAIN_HIGHLIGHT forState:UIControlStateNormal];
    mobileButton.titleLabel.font = FONT_MAIN;
    mobileButton.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:mobileButton];
    
    [mobileButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(avatarView.mas_right).offset(padding);
        make.bottom.equalTo(avatarView.mas_bottom).offset(-5);
        
        make.height.equalTo(@16);
    }];
    
    //投诉
    UIButton *complainButton = [[UIButton alloc] init];
    [complainButton setTitleColor:COLOR_MAIN_HIGHLIGHT forState:UIControlStateNormal];
    [complainButton setTitle:@"官方客服" forState:UIControlStateNormal];
    [complainButton addTarget:self action:@selector(actionComplain) forControlEvents:UIControlEventTouchUpInside];
    complainButton.titleLabel.font = FONT_MIDDLE;
    complainButton.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:complainButton];
    
    [complainButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.bottom.equalTo(superview.mas_bottom).offset(-15);
        
        make.height.equalTo(@16);
    }];
    
    return self;
}

- (void) stopMap
{
    if (mapWebView) {
        [mapWebView stopLoading];
        mapWebView.delegate = nil;
        [mapWebView removeFromSuperview];
        mapWebView = nil;
    }
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
    nameLabel.text = intention.staffName;
    [mobileButton setTitle:intention.staffMobile forState:UIControlStateNormal];
    [mobileButton addTarget:self action:@selector(actionMobile) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - WebView
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
    
    mapWebView.opaque = YES;
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
