//
//  AddressFormViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressFormViewController.h"
#import "AddressFormView.h"

@interface AddressFormViewController () <AddressFormViewDelegate>

@end

@implementation AddressFormViewController
{
    AddressFormView *addressFormView;
}

@synthesize address;

- (void)loadView
{
    addressFormView = [[AddressFormView alloc] init];
    addressFormView.delegate = self;
    self.view = addressFormView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新建地址";
    
    //初始化默认
    if (self.address == nil) {
        self.address = [[AddressEntity alloc] init];
    }
    
    [addressFormView setData:@"address" value:self.address];
    [addressFormView renderData];
}

@end
