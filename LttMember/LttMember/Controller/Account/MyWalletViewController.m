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
#import "PayPasswordViewController.h"

@interface MyWalletViewController ()<MyWalletViewDelegate>

@end

@implementation MyWalletViewController
{
    MyWalletView *myWalletView;
}

- (void)loadView
{
    myWalletView = [[MyWalletView alloc] init];
    myWalletView.delegate = self;
    self.view = myWalletView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的钱包";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getAccount];
}

- (void)actionBalance
{
    BalanceListViewController *viewController = [[BalanceListViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionRecharge
{
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //是否设置支付密码
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler issetPayPassword:nil success:^(NSArray *result) {
        [self hideLoading];
        
        ResultEntity *entity = [result firstObject];
        //已设置支付密码
        if (entity.data && [@1 isEqualToNumber:entity.data]) {
            RechargeViewController *viewController = [[RechargeViewController alloc] init];
            [self pushViewController:viewController animated:YES];
        //未设置支付密码
        } else {
            PayPasswordViewController *viewController = [[PayPasswordViewController alloc] init];
            //先设置支付密码，成功后跳转支付
            viewController.callbackBlock = ^(id object){
                RechargeViewController *viewController = [[RechargeViewController alloc] init];
                [self replaceViewController:viewController animate:YES];
            };
            [self pushViewController:viewController animated:YES];
        }
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
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
