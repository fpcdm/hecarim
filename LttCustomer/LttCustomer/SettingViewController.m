//
//  SettingViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingView.h"

@interface SettingViewController () <SettingViewDelegate>

@end

@implementation SettingViewController
{
    SettingView *settingView;
}

- (void)loadView
{
    settingView = [[SettingView alloc] init];
    settingView.delegate = self;
    self.view = settingView;
}

- (void)viewDidLoad
{
    showBackBar = YES;
    [super viewDidLoad];
    
    self.title = @"设置";
}

@end
