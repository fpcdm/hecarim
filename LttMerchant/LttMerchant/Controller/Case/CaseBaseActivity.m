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

#pragma mark - Data
//加载需求并显示
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
        [self showError:error.message];
    }];
}

#pragma mark - reloadData
//渲染需求头数据
- (void) renderCaseData
{
    NSString *totalAmount = self.intention.totalAmount && [self.intention.totalAmount floatValue] > 0.0 ? [NSString stringWithFormat:@"￥%@", self.intention.totalAmount] : @"-";
    self.viewStorage[@"case"] = @{
                                  @"no": self.intention.no,
                                  @"status": self.intention.status,
                                  @"statusName": self.intention.statusName,
                                  @"time": self.intention.createTime,
                                  @"totalAmount":totalAmount
                                  };
}

@end
