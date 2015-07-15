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
}

#pragma mark - Action
- (void) actionAddress
{
    AddressSelectorViewController *viewController = [[AddressSelectorViewController alloc] init];
    viewController.callbackBlock = ^(AddressEntity *address){
        NSLog(@"选择的地址：%@", [address toDictionary]);
    };
    
    [self pushViewController:viewController animated:YES];
}

- (void) actionSubmit:(NSString *)remark
{
    //获取参数
    caseEntity.remark = remark;
    
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
