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
    
    //加载数据
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    [safetyView setData:@"user" value:user];
    [safetyView renderData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账户与安全";
}

//自动刷新
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (needRefresh) {
        NSLog(@"刷新了");
        needRefresh = NO;
        [safetyView renderData];
    }
    
    NSLog(@"刷新了dddd");
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
    viewController.callbackBlock = ^(id object){
        //标记可刷新
        if (object && [@1 isEqualToNumber:object]) {
            needRefresh = YES;
        }
    };

    [self pushViewController:viewController animated:YES];
}

@end
