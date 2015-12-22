//
//  MyWalletViewController.m
//  LttMember
//
//  Created by 杨海锋 on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletView.h"
#import "BalanceListViewController.h"
#import "RechargeViewController.h"
#import "UserHandler.h"

@interface MyWalletViewController ()<MyWalletViewDelegate>

@end

@implementation MyWalletViewController
{
    MyWalletView *myWalletView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myWalletView = [[MyWalletView alloc] init];
    myWalletView.delegate = self;
    self.view = myWalletView;
    
    [self getAccount];
    
    self.navigationItem.title = @"我的钱包";
}

- (void)actionBalance
{
    BalanceListViewController *viewController = [[BalanceListViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionRecharge
{
    RechargeViewController *viewController = [[RechargeViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)getAccount
{
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler getAccount:nil success:^(NSArray *result) {
        ResultEntity *resultEntity = [result firstObject];
        NSString *account = resultEntity.data;
        [myWalletView setData:@"account" value:account];
        [myWalletView renderData];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

@end
