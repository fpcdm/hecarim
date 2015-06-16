//
//  AddressDetailViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "AddressDetailView.h"

@interface AddressDetailViewController () <AddressDetailViewDelegate>

@end

@implementation AddressDetailViewController
{
    AddressDetailView *addressDetailView;
}

@synthesize address;

- (void)loadView
{
    addressDetailView = [[AddressDetailView alloc] init];
    addressDetailView.delegate = self;
    self.view = addressDetailView;
    
    [addressDetailView setData:@"address" value:self.address];
    [addressDetailView renderData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的地址";
}

@end
