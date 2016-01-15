//
//  AddressViewController.m
//  LttAutoFinance
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressView.h"
#import "AddressEntity.h"
#import "AddressDetailViewController.h"
#import "AddressFormViewController.h"
#import "UserHandler.h"

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
    [super viewDidLoad];
    
    self.navigationItem.title = @"管理我的地址";
    
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonSystemItem:UIBarButtonSystemItemAdd];
    barButtonItem.target = self;
    barButtonItem.action = @selector(actionAdd);
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    //加载数据
    [self showLoading:TIP_LOADING_MESSAGE];
    [self loadData:^(id object){
        [self hideLoading];
        
        [addressView setData:@"addressList" value:addressList];
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
- (void) actionAdd
{
    AddressFormViewController *viewController = [[AddressFormViewController alloc] init];
    
    //是否默认
    if (!addressList || [addressList count] < 1) {
        viewController.isDefault = @1;
    }
    
    //添加回调
    viewController.callbackBlock = ^(id object){
        [addressList addObject:(AddressEntity *) object];
        
        [addressView setData:@"addressList" value:addressList];
        [addressView renderData];
    };
    
    [self pushViewController:viewController animated:YES];
}

- (void) actionDetail:(AddressEntity *)address
{
    AddressDetailViewController *viewController = [[AddressDetailViewController alloc] init];
    
    //拷贝对象
    viewController.address = [address copy];
    //修改回调
    viewController.callbackBlock = ^(id object){
        AddressEntity *newAddress = (AddressEntity *) object;
        
        int index = 0;
        for (AddressEntity *address in addressList) {
            if (newAddress.id && [address.id isEqualToNumber:newAddress.id]) {
                [addressList replaceObjectAtIndex:index withObject:newAddress];
                break;
            }
            index++;
        }
        
        [addressView setData:@"addressList" value:addressList];
        [addressView renderData];
    };
    //删除回调
    viewController.deleteBlock = ^(id object){
        AddressEntity *newAddress = (AddressEntity *) object;
        
        for (AddressEntity *address in addressList) {
            if (newAddress.id && [address.id isEqualToNumber:newAddress.id]) {
                [addressList removeObject:address];
                break;
            }
        }
        
        [addressView setData:@"addressList" value:addressList];
        [addressView renderData];
    };
    //设置默认回调
    viewController.defaultBlock = ^(id object){
        AddressEntity *newAddress = (AddressEntity *) object;
        
        //将其它设置非默认
        for (AddressEntity *address in addressList) {
            if (newAddress.id && [address.id isEqualToNumber:newAddress.id]) {
                address.isDefault = @1;
            } else {
                address.isDefault = @0;
            }
        }
        
        [addressView setData:@"addressList" value:addressList];
        [addressView renderData];
    };
    
    [self pushViewController:viewController animated:YES];
}

@end
