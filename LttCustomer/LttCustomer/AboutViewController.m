//
//  AboutViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/29.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutView.h"

@interface AboutViewController () <AboutViewDelegate>

@end

@implementation AboutViewController
{
    AboutView *aboutView;
}

- (void)loadView
{
    aboutView = [[AboutView alloc] init];
    aboutView.delegate = self;
    self.view = aboutView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于两条腿";
}

#pragma mark - Action
- (void)actionScore
{
    
}

@end
