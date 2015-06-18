//
//  AddressDetailViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "AddressDetailView.h"
#import "AddressFormViewController.h"

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
    hasNavBack = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的地址";
    
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonSystemItem:UIBarButtonSystemItemEdit];
    barButtonItem.target = self;
    barButtonItem.action = @selector(actionEdit);
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - Action
//删除地址
- (void) actionDelete
{
    //@todo: 删除地址
    
    [self.navigationController popViewControllerAnimated:YES];
}

//设为默认地址
- (void) actionDefault
{
    //@todo: 设置默认
    
    [self.navigationController popViewControllerAnimated:YES];
}

//编辑页面
- (void) actionEdit
{
    AddressFormViewController *viewController = [[AddressFormViewController alloc] init];
    //拷贝对象
    viewController.address = [address copy];
    [self pushViewController:viewController animated:YES];
}

@end
