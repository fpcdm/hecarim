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
#import "HelperHandler.h"
#import "ValidateUtil.h"
#import "UserHandler.h"

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
        self.address.isDefault = self.isDefault ? self.isDefault : @0;
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
- (void)pickFinish:(AddressEntity *) newAddress
{
    self.address.provinceId = newAddress.provinceId;
    self.address.provinceName = newAddress.provinceName;
    self.address.cityId = newAddress.cityId;
    self.address.cityName = newAddress.cityName;
    self.address.countyId = newAddress.countyId;
    self.address.countyName = newAddress.countyName;
    
    NSLog(@"选择的地址：%@", [self.address toDictionary]);
    
    [addressFormView renderData];
}

#pragma mark - Action
- (void)actionSave
{
    //获取数据
    self.address.name = addressFormView.nameField.text;
    self.address.mobile = addressFormView.mobileField.text;
    self.address.address = addressFormView.addressView.text;
    
    //参数检查
    if (![ValidateUtil isRequired:self.address.name]) {
        [self showError:@"请填写联系人姓名"];
        return;
    }
    if (![ValidateUtil isRequired:self.address.mobile]) {
        [self showError:@"请填写手机号码"];
        return;
    }
    if (![ValidateUtil isMobile:self.address.mobile]) {
        [self showError:@"手机号码格式不正确"];
        return;
    }
    if (!self.address.streetId || [self.address.streetId floatValue] < 1) {
        [self showError:@"请选择区域"];
        return;
    }
    if (![ValidateUtil isRequired:self.address.address]) {
        [self showError:@"请填写详细地址"];
        return;
    }
    
    NSLog(@"地址数据：%@", [self.address toDictionary]);
    
    //新增
    if (!self.address.id || [self.address.id intValue] < 1) {
        //保存地址
        UserHandler *userHandler = [[UserHandler alloc] init];
        [userHandler addAddress:self.address success:^(NSArray *result){
            AddressEntity *resultEntity = [result firstObject];
            
            self.address.id = resultEntity.id;
            
            //执行回调
            if (self.callbackBlock) {
                self.callbackBlock(self.address);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    //编辑
    } else {
        //保存地址
        UserHandler *userHandler = [[UserHandler alloc] init];
        [userHandler editAddress:self.address success:^(NSArray *result){
            //执行回调
            if (self.callbackBlock) {
                self.callbackBlock(self.address);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    }
}

- (void)actionArea
{
    AppAddressPicker *addressPicker = [[AppAddressPicker alloc] init];
    addressPicker.delegate = self;
    [addressPicker loadData:^{
        [ActionSheetCustomPicker showPickerWithTitle:nil delegate:addressPicker showCancelButton:YES origin:addressFormView];
    }];
}

- (void)actionStreet
{
    //是否选择区县
    if (!self.address.countyId || [self.address.countyId floatValue] < 1) {
        [self showError:@"请先选择地区"];
        return;
    }
    
    //查询街道
    AreaEntity *countyEntity = [[AreaEntity alloc] init];
    countyEntity.code = self.address.countyId;
    
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler queryAreas:countyEntity success:^(NSArray *result){
        NSMutableArray *streets = [[NSMutableArray alloc] init];
        NSArray *streetEntitys = result;
        
        for (AreaEntity *street in streetEntitys) {
            [streets addObject:(street.name ? street.name : @"")];
        }
        
        //选择街道
        [ActionSheetStringPicker showPickerWithTitle:nil rows:streets initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue){
            AreaEntity *selectedStreet = [streetEntitys objectAtIndex:selectedIndex];
            if (selectedStreet) {
                self.address.streetId = selectedStreet.code;
                self.address.streetName = selectedStreet.name;
                
                [addressFormView renderData];
            }
        } cancelBlock:^(ActionSheetStringPicker *picker){} origin:addressFormView];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

@end
