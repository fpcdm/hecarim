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
    
    //初始化默认
    if (self.address == nil) {
        self.address = [[AddressEntity alloc] init];
        self.navigationItem.title = @"新建地址";
    } else {
        self.navigationItem.title = @"编辑地址";
    }
    
    //保存按钮
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonItem:@"保存"];
    barButtonItem.target = self;
    barButtonItem.action = @selector(actionSave);
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    //视图赋值
    [addressFormView setData:@"address" value:self.address];
    [addressFormView renderData];
}

#pragma mark - Action
- (void)actionSave
{
    //@todo 保存
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
