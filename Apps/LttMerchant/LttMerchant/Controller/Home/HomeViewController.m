//
//  HomeViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeViewController.h"
#import "CaseListViewController.h"
#import "HomeView.h"
#import "StaffListViewController.h"
#import "StaffEntity.h"
#import "StaffHandler.h"

@interface HomeViewController ()<HomeViewDelegate>

@end

@implementation HomeViewController
{
    HomeView *homeView;
}

- (void)viewDidLoad
{
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    
    [super viewDidLoad];
    
    homeView = [[HomeView alloc] init];
    homeView.delegate = self;
    self.navigationItem.title = @"两条腿工作台";
    self.view = homeView;
    self.view.backgroundColor = COLOR_MAIN_BG;
    
    //刷新gps
    [[LocationUtil sharedInstance] restartUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //检查用户权限
    StaffHandler *staffHandler = [[StaffHandler alloc] init];
    [staffHandler userPermissions:nil success:^(NSArray *result) {
        StaffEntity *staffEntity = [result firstObject];
        [homeView assign:@"is_admin" value:staffEntity.is_admin];
        [homeView display];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}



#pragma mark - Action
- (void)actionCaseList
{
    CaseListViewController *viewController = [[CaseListViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionStaff
{
    StaffListViewController *staffViewController = [[StaffListViewController alloc] init];
    [self pushViewController:staffViewController animated:YES];
}

@end
