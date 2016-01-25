//
//  ServiceFormViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceFormViewController.h"
#import "CategoryEntity.h"
#import "ServiceEntity.h"
#import "GoodsHandler.h"
#import "CaseHandler.h"
#import "ServiceFromView.h"

@interface ServiceFormViewController ()<ServiceFromViewDelegate>

@end

@implementation ServiceFormViewController
{
    ServiceFromView *serviceFromView;
}

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    [self setCaseNoAndStatusName];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadCase];
    
}

- (void)setCaseNoAndStatusName
{
    serviceFromView = [[ServiceFromView alloc] init];
    serviceFromView.delegate = self;
    
    self.navigationItem.title = @"服务添加";
    self.view = serviceFromView;
    self.view.backgroundColor = COLOR_MAIN_BG;
    

}

#pragma mark - reloadData
- (void) reloadData
{
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.no = self.intention.no;
    caseEntity.status = self.intention.status;
    [serviceFromView assign:@"caseEntity" value:caseEntity];
    [serviceFromView display];
}

#pragma mark - Action
- (void)actionSave:(NSString *)remark price:(NSString *)price
{
    //内容
    if (![ValidateUtil isRequired:remark]) {
        [self showError:[LocaleUtil error:@"ServiceName.Required"]];
        return;
    }
    
    //价格
    if (![ValidateUtil isRequired:price]) {
        [self showError:[LocaleUtil error:@"ServicePrice.Required"]];
        return;
    }
    if (![ValidateUtil isPositiveNumber:price]) {
        [self showError:[LocaleUtil error:@"ServicePrice.Format"]];
        return;
    }
    
    //获取服务列表
    CaseEntity *postCase = [[CaseEntity alloc] init];
    postCase.id = self.caseId;
    
    BOOL isEdit = intention.services && [intention.services count] > 0 ? YES : NO;
    //获取之前的服务列表
    NSMutableArray *serviceList = [[NSMutableArray alloc] init];
    if (isEdit) {
        for (ServiceEntity *entity in intention.services) {
            [serviceList addObject:entity];
        }
    }
    
    //添加当前服务
    ServiceEntity *currentService = [[ServiceEntity alloc] init];
    currentService.typeId = @(LTT_SERVICE_CATEGORYID);
    currentService.typeName = LTT_SERVICE_CATEGORYNAME;
    currentService.name = remark;
    currentService.price = [NSNumber numberWithFloat:[price floatValue]];
    [serviceList addObject:currentService];
    
    //转换数据
    postCase.services = serviceList;
    postCase.servicesParam = [postCase formatFormServices];
    postCase.services = nil;
    
    //提交数据
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    //新增
    if (!isEdit) {
        [caseHandler addCaseServices:postCase success:^(NSArray *result){
            [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
                //通知刷新
                if (self.callbackBlock) {
                    self.callbackBlock(@1);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
        //编辑
    } else {
        [caseHandler editCaseServices:postCase success:^(NSArray *result){
            [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
                //通知刷新
                if (self.callbackBlock) {
                    self.callbackBlock(@1);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    }
}

@end
