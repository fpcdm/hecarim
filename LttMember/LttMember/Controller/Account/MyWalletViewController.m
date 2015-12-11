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

@interface MyWalletViewController ()<MyWalletViewDelegate>

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyWalletView *myWalletView = [[MyWalletView alloc] init];
    myWalletView.delegate = self;
    self.view = myWalletView;
    
    self.navigationItem.title = @"我的钱包";
}

- (void)actionBalance
{
    BalanceListViewController *viewController = [[BalanceListViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionRecharge
{
    
}

- (void)actionMyBankCard
{

}



@end
