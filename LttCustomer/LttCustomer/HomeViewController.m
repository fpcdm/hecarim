//
//  RootViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"

@interface HomeViewController () <HomeViewDelegate>

@end

@implementation HomeViewController
{
    HomeView *homeView;
}

- (void)loadView
{
    homeView = [[HomeView alloc] init];
    homeView.delegate = self;
    self.view = homeView;
}

- (void)viewDidLoad
{
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
}

@end
