//
//  ProtocolViewController.m
//  LttMember
//
//  Created by wuyong on 15/12/11.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "ProtocolViewController.h"
#import "ProtocolView.h"

@interface ProtocolViewController () <ProtocolViewDelegate>

@end

@implementation ProtocolViewController
{
    ProtocolView *protocolView;
}

- (void)loadView
{
    protocolView = [[ProtocolView alloc] init];
    protocolView.delegate = self;
    self.view = protocolView;
}

- (void)viewDidLoad {
    isMenuEnabled = NO;
    hideBackButton = NO;
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务协议";
    
    [protocolView assign:@"url" value:URL_REGISTER_PROTOCOL];
    [protocolView display];
}

//关闭计时器
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //停止加载
    [protocolView stopWeb];
}

@end
