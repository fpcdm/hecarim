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

@interface AddressViewController () <AddressViewDelegate>

@end

@implementation AddressViewController
{
    AddressView *addressView;
}

- (void)loadView
{
    addressView = [[AddressView alloc] init];
    addressView.delegate = self;
    self.view = addressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"管理我的地址";
    
    //初始化数据
    NSMutableArray *addressList = [[NSMutableArray alloc] initWithObjects:nil];
    
    AddressEntity *address = [[AddressEntity alloc] init];
    address.id = @1;
    address.isDefault = YES;
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
    
    [addressView setData:@"addressList" value:addressList];
    [addressView renderData];
}

@end
