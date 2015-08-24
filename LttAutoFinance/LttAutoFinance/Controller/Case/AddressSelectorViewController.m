//
//  AddressViewController.m
//  LttAutoFinance
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressSelectorViewController.h"
#import "AddressSelectorView.h"
#import "AddressEntity.h"
#import "UserHandler.h"
#import "AddressViewController.h"

@interface AddressSelectorViewController () <AddressSelectorViewDelegate>

@end

@implementation AddressSelectorViewController
{
    AddressSelectorView *addressView;
    NSMutableArray *addressList;
}

@synthesize currentAddress;

- (void)loadView
{
    addressView = [[AddressSelectorView alloc] init];
    addressView.delegate = self;
    self.view = addressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择服务地址";
    
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonItem:@"管理地址"];
    barButtonItem.target = self;
    barButtonItem.action = @selector(actionManageAddress);
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

//自动刷新收货地址
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //加载数据
    [self loadData:^(id object){
        [addressView setData:@"addressList" value:addressList];
        [addressView setData:@"currentAddress" value:currentAddress];
        [addressView renderData];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void) loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //初始化数据
    addressList = [[NSMutableArray alloc] initWithObjects:nil];
    
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler queryUserAddresses:nil success:^(NSArray *result){
        for (AddressEntity *address in result) {
            [addressList addObject:address];
        }
        success(nil);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

#pragma mark - Action
- (void) actionManageAddress
{
    AddressViewController *viewController = [[AddressViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void) actionSelected:(AddressEntity *)address
{
    if (self.callbackBlock) {
        self.callbackBlock(address);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
