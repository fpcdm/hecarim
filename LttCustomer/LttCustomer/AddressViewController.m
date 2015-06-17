//
//  AddressViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressView.h"
#import "AddressEntity.h"
#import "AddressDetailViewController.h"
#import "AddressFormViewController.h"

@interface AddressViewController () <AddressViewDelegate>

@end

@implementation AddressViewController
{
    AddressView *addressView;
    NSMutableArray *addressList;
}

- (void)loadView
{
    addressView = [[AddressView alloc] init];
    addressView.delegate = self;
    self.view = addressView;
}

- (void)viewDidLoad {
    hasNavBack = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"管理我的地址";
    
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonSystemItem:UIBarButtonSystemItemAdd];
    barButtonItem.target = self;
    barButtonItem.action = @selector(actionAdd);
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    [self loadData];
}

- (void) loadData
{
    //初始化数据
    addressList = [[NSMutableArray alloc] initWithObjects:nil];
    
    AddressEntity *address = [[AddressEntity alloc] init];
    address.id = @1;
    address.isDefault = @YES;
    address.name = @"吴勇";
    address.mobile = @"18875001455";
    address.provinceId = @1;
    address.cityId = @2;
    address.countyId = @3;
    address.streetId = @4;
    address.provinceName = @"重庆";
    address.cityName = @"重庆市";
    address.countyName = @"渝北区";
    address.streetName = @"龙山街道";
    address.address = @"龙山大道111号龙湖紫都星座B座1608";
    [addressList addObject:address];
    
    AddressEntity *address2 = [[AddressEntity alloc] init];
    address2.id = @2;
    address2.isDefault = @NO;
    address2.name = @"某某";
    address2.mobile = @"13333333333";
    address2.provinceId = @1;
    address2.cityId = @2;
    address2.countyId = @3;
    address2.streetId = @4;
    address2.provinceName = @"重庆";
    address2.cityName = @"重庆市";
    address2.countyName = @"渝北区";
    address2.streetName = @"龙山街道";
    address2.address = @"龙山大道111号龙湖紫都星座B座1608";
    [addressList addObject:address2];
    
    [addressView setData:@"addressList" value:addressList];
    [addressView renderData];
}

#pragma mark - Action
- (void) actionAdd
{
    AddressFormViewController *viewController = [[AddressFormViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void) actionDetail:(AddressEntity *)address
{
    AddressDetailViewController *viewController = [[AddressDetailViewController alloc] init];
    //拷贝对象
    viewController.address = [address copy];
    [self pushViewController:viewController animated:YES];
}

@end
