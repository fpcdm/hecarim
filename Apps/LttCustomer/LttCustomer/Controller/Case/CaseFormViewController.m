//
//  CaseFormViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/7/14.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseFormViewController.h"
#import "CaseFormView.h"
#import "CaseViewController.h"
#import "CaseHandler.h"
#import "AddressSelectorViewController.h"
#import "AddressEntity.h"
#import "UserHandler.h"

@interface CaseFormViewController () <CaseFormViewDelegate>

@end

@implementation CaseFormViewController
{
    CaseFormView *formView;
}

@synthesize caseEntity;

- (void)loadView
{
    formView = [[CaseFormView alloc] init];
    formView.delegate = self;
    self.view = formView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"呼叫客服";
    
    //查询默认收货地址
    [self showLoading:TIP_LOADING_MESSAGE];
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler queryUserDefaultAddress:nil success:^(NSArray *result){
        [self hideLoading];
        
        if ([result count] > 0) {
            AddressEntity *address = [result firstObject];
            [self addressView:address];
        } else {
            [self addressView:[self currentAddress]];
        }
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void) addressView: (AddressEntity *) address
{
    //地址存在
    if (address && address.id) {
        [formView setData:@"name" value:address.name];
        [formView setData:@"mobile" value:address.mobile];
        NSString *detailAddress = [NSString stringWithFormat:@"%@%@%@%@%@", address.provinceName, address.cityName, address.countyName, address.streetName, address.address];
        [formView setData:@"address" value:detailAddress];
        [formView renderData];
        
        caseEntity.addressId = address.id;
    } else {
        [formView setData:@"name" value:address.name];
        [formView setData:@"mobile" value:address.mobile];
        [formView setData:@"address" value:address.address];
        [formView renderData];
        
        caseEntity.addressId = nil;
    }
}

- (AddressEntity *) currentAddress
{
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    
    AddressEntity *currentAddress = [[AddressEntity alloc] init];
    currentAddress.name = [user displayName];
    currentAddress.mobile = user.mobile;
    currentAddress.address = caseEntity.buyerAddress;
    return currentAddress;
}

#pragma mark - Action
- (void) actionAddress
{
    AddressSelectorViewController *viewController = [[AddressSelectorViewController alloc] init];
    //获取当前地址
    viewController.currentAddress = [self currentAddress];
    viewController.callbackBlock = ^(AddressEntity *address){
        NSLog(@"选择的地址：%@", [address toDictionary]);
        
        [self addressView:address];
    };
    
    [self pushViewController:viewController animated:YES];
}

- (void) actionSubmit:(NSString *)remark
{
    //参数检查
    if ((!caseEntity.addressId || [caseEntity.addressId isEqualToNumber:@0]) &&
        ![ValidateUtil isRequired:caseEntity.buyerAddress]
        ) {
        [self showError:@"请先选择服务地址哦~亲！"];
        return;
    }
    
    //获取参数
    caseEntity.customerRemark = remark;
    
    NSLog(@"intention: %@", [caseEntity toDictionary]);
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler addIntention:caseEntity success:^(NSArray *result){
        CaseEntity *intention = [result firstObject];
        
        NSLog(@"新增需求id: %@", intention.id);
        
        //跳转需求详情
        CaseViewController *viewController = [[CaseViewController alloc] init];
        viewController.caseId = intention.id;
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            [self pushViewController:viewController animated:YES];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

@end
