//
//  CaseBaseActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/8/3.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseBaseActivity.h"

@interface CaseBaseActivity ()

@end

@implementation CaseBaseActivity

#pragma mark - View
- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
}

- (void)onTemplateFailed
{
    
}

- (void)onTemplateCancelled
{
    
}

#pragma mark - Data
//加载需求数据并重新渲染
- (void) loadCase
{
    [self loadCase:^(id object){
        [self reloadData];
    }];
}

//加载需求数据并执行回调
- (void) loadCase:(CallbackBlock)callback
{
    //加载数据
    [self showLoading:TIP_LOADING_MESSAGE];
    
    //查询需求
    NSLog(@"caseId: %@", self.caseId);
    
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler queryCase:intentionEntity success:^(NSArray *result){
        [self hideLoading];
        
        self.intention = [result firstObject];
        
        NSLog(@"需求数据：%@", [self.intention toDictionary]);
        
        callback(nil);
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        
        [self loadError:error];
    }];
}

#pragma mark - loadError
//默认错误处理，子类可重写
- (void) loadError:(ErrorEntity *)error
{
    [self showError:error.message];
}

#pragma mark - reloadData
//子类重写，渲染数据
- (void) reloadData
{
    [self renderCaseData];
    
    //子类继续渲染
}

//渲染需求头数据
- (void) renderCaseData
{
}

@end
