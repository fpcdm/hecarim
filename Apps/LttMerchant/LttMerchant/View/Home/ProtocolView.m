//
//  ProtocolView.m
//  LttMember
//
//  Created by wuyong on 15/12/11.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "ProtocolView.h"

@interface ProtocolView () <UIWebViewDelegate>

@end

@implementation ProtocolView
{
    UIWebView *webView;
    
    UIActivityIndicatorView *indicatorView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //地图视图
    webView = [[UIWebView alloc] init];
    webView.scrollView.bounces = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.backgroundColor = COLOR_MAIN_WHITE;
    webView.opaque = NO;
    webView.delegate = self;
    [self addSubview:webView];
    
    UIView *superview = self;
    [webView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
    }];
    
    //加载中
    indicatorView = [[UIActivityIndicatorView alloc] init];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addSubview:indicatorView];
    
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(webView.mas_centerX);
        make.centerY.equalTo(webView.mas_centerY);
        
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    return self;
}

- (void) stopWeb
{
    if (webView) {
        [webView stopLoading];
        webView.delegate = nil;
        [webView removeFromSuperview];
        webView = nil;
    }
}

#pragma mark - RenderData
- (void)display
{
    //加载网页
    NSURL *url =[NSURL URLWithString:[self fetch:@"url"]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - WebView
- (void)webViewDidStartLoad:(UIWebView *)_webView
{
    [indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
    
    webView.opaque = YES;
}

@end
