//
//  AddressFormViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressFormViewController.h"
#import "AddressFormView.h"
#import "AppAddressPicker.h"

@interface AddressFormViewController () <AddressFormViewDelegate, AppAddressPickerDelegate>

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

#pragma mark - Delegate
- (void)pickFinish:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    //todo: 修改其他数据
    
    self.address.provinceName = province;
    self.address.cityName = city;
    self.address.countyName = area;
    [addressFormView renderData];
}

#pragma mark - Action
- (void)actionSave
{
    //@todo 保存
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionArea
{
    AppAddressPicker *addressPicker = [[AppAddressPicker alloc] init];
    addressPicker.delegate = self;
    
    [ActionSheetCustomPicker showPickerWithTitle:nil delegate:addressPicker showCancelButton:YES origin:addressFormView];
}

- (void)actionStreet
{
    //获取街道列表
    NSArray *streets = @[@"街道1", @"街道2", @"街道3"];
    
    //选择街道
    [ActionSheetStringPicker showPickerWithTitle:nil rows:streets initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue){
        //@todo 设置街道id
        self.address.streetName = selectedValue;
        [addressFormView renderData];
    } cancelBlock:^(ActionSheetStringPicker *picker){} origin:addressFormView];
}

@end
