//
//  RootViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    HomeView *homeView;
}

- (void)loadView
{
    homeView = [[HomeView alloc] init];
    self.view = homeView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"首页";
}

- (BOOL) hasTabBar
{
    return YES;
}

@end
