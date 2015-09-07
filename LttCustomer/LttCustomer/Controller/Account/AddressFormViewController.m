//
//  AddressFormViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressFormViewController.h"
#import "AddressFormView.h"
#import "HelperHandler.h"
#import "ValidateUtil.h"
#import "UserHandler.h"
#import "PickerUtil.h"

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
    [self showLoading:TIP_LOADING_MESSAGE];
    
    //变量缓存
    AreaEntity *requestArea = [[AreaEntity alloc] init];
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    
    //地址选择器
    PickerUtil *pickerUtil = [[PickerUtil alloc] initWithTitle:nil grade:3 origin:addressFormView];
    pickerUtil.firstLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
        //查询省列表
        requestArea.code = @0;
        
        [helperHandler queryAreas:requestArea success:^(NSArray *result){
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (AreaEntity *area in result) {
                [rows addObject:[PickerUtilRow rowWithName:area.name ? area.name : @"" value:area]];
            }
            
            completionHandler(rows);
        } failure:^(ErrorEntity *error){
            [self hideLoading];
        }];
    };
    
    pickerUtil.secondLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
        //查询市列表
        PickerUtilRow *firstRow = [selectedRows objectAtIndex:0];
        AreaEntity *province = firstRow.value;
        requestArea.code = province.code;
        
        [helperHandler queryAreas:requestArea success:^(NSArray *result){
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (AreaEntity *area in result) {
                [rows addObject:[PickerUtilRow rowWithName:area.name ? area.name : @"" value:area]];
            }
            
            completionHandler(rows);
        } failure:^(ErrorEntity *error){
            [self hideLoading];
        }];
    };
    
    pickerUtil.thirdLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
        //查询县列表
        PickerUtilRow *secondRow = [selectedRows objectAtIndex:1];
        AreaEntity *city = secondRow.value;
        requestArea.code = city.code;
        
        [helperHandler queryAreas:requestArea success:^(NSArray *result){
            [self hideLoading];
            
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (AreaEntity *area in result) {
                [rows addObject:[PickerUtilRow rowWithName:area.name ? area.name : @"" value:area]];
            }
            
            completionHandler(rows);
        } failure:^(ErrorEntity *error){
            [self hideLoading];
        }];
    };
    
    pickerUtil.resultBlock = ^(NSArray *selectedRows){
        PickerUtilRow *firstRow = [selectedRows objectAtIndex:0];
        AreaEntity *province = firstRow.value;
        PickerUtilRow *secondRow = [selectedRows objectAtIndex:1];
        AreaEntity *city = secondRow.value;
        PickerUtilRow *thirdRow = [selectedRows objectAtIndex:2];
        AreaEntity *county = thirdRow.value;
        
        self.address.provinceId = province.code;
        self.address.provinceName = province.name;
        self.address.cityId = city.code;
        self.address.cityName = city.name;
        self.address.countyId = county.code;
        self.address.countyName = county.name;
        
        NSLog(@"选择的地址：%@", [self.address toDictionary]);
        
        [addressFormView renderData];
    };
    
    [pickerUtil show];
}

- (void)actionStreet
{
    //是否选择区县
    if (!self.address.countyId || [self.address.countyId floatValue] < 1) {
        [self showError:@"请先选择地区"];
        return;
    }
    
    [self showLoading:TIP_LOADING_MESSAGE];
    
    //街道选择器
    PickerUtil *pickerUtil = [[PickerUtil alloc] initWithTitle:nil grade:1 origin:addressFormView];
    pickerUtil.firstLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
        //查询街道
        AreaEntity *countyEntity = [[AreaEntity alloc] init];
        countyEntity.code = self.address.countyId;
        
        HelperHandler *helperHandler = [[HelperHandler alloc] init];
        [helperHandler queryAreas:countyEntity success:^(NSArray *result){
            [self hideLoading];
            
            //初始化行数据
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (AreaEntity *street in result) {
                [rows addObject:[PickerUtilRow rowWithName:street.name ? street.name : @"" value:street]];
            }
            
            //回调数据
            completionHandler(rows);
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    };
    pickerUtil.resultBlock = ^(NSArray *selectedRows){
        PickerUtilRow *row = [selectedRows objectAtIndex:0];
        AreaEntity *selectedStreet = row.value;
        
        self.address.streetId = selectedStreet.code;
        self.address.streetName = selectedStreet.name;
            
        [addressFormView renderData];
    };
    [pickerUtil show];
}

@end
