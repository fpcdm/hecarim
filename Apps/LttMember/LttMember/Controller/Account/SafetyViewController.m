//
//  SafetyViewController.m
//  LttMember
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SafetyViewController.h"
#import "SafetyView.h"
#import "SafetyPasswordViewController.h"
#import "PayPasswordViewController.h"
#import "UserHandler.h"

@interface SafetyViewController () <SafetyViewDelegate>

@end

@implementation SafetyViewController
{
    SafetyView *safetyView;
    
    BOOL needRefresh;
}

- (void)loadView
{
    safetyView = [[SafetyView alloc] init];
    safetyView.delegate = self;
    self.view = safetyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账户与安全";
}

//自动刷新
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showLoading:[LocaleUtil system:@"Loading.Start"]];
    
    UserHandler *userhandler = [[UserHandler alloc] init];
    [userhandler issetPayPassword:nil success:^(NSArray *result) {
        [self hideLoading];
        
        ResultEntity *resultEntity = [result firstObject];
        //加载数据
        UserEntity *user = [[StorageUtil sharedStorage] getUser];
        
        NSDictionary *assignDic = @{
                                    @"user" : user,
                                    @"payRes" : resultEntity.data
                                    };
        [safetyView assign:assignDic];
        
        [safetyView display];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

#pragma mark - Action
- (void)actionPassword
{
    SafetyPasswordViewController *viewController = [[SafetyPasswordViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionPayPassword
{
    PayPasswordViewController *viewController = [[PayPasswordViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

@end
