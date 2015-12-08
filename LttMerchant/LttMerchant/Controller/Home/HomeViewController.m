//
//  HomeViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeViewController.h"
#import "CaseListViewController.h"
#import "LocationUtil.h"
#import "HomeView.h"

@interface HomeViewController ()<HomeViewDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    
    [super viewDidLoad];
    
    HomeView *homeView = [[HomeView alloc] init];
    homeView.delegate = self;
    self.navigationItem.title = @"两条腿工作台";
    self.view = homeView;
    self.view.backgroundColor = COLOR_MAIN_BG;
    
    //刷新gps
    [[LocationUtil sharedInstance] restartUpdate];
}



#pragma mark - Action
- (void)actionCaseList
{
    CaseListViewController *viewController = [[CaseListViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

@end
