//
//  CaseHandler.h
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "CaseEntity.h"
#import "GoodsEntity.h"
#import "ServiceEntity.h"

@interface CaseHandler : BaseHandler

- (void) queryCase: (CaseEntity *) caseEntity success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryCases: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//抢单
- (void) competeCase: (CaseEntity *) caseEntity success: (SuccessBlock) success failure: (FailedBlock) failure;

//弃单
- (void) giveupCase: (CaseEntity *) caseEntity success: (SuccessBlock) success failure: (FailedBlock) failure;

//修改需求状态
- (void) updateCaseStatus: (CaseEntity *) caseEntity param: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//现金支付需求
- (void) payWithCash:(CaseEntity *)caseEntity param: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//支付方式列表
- (void) queryPayments: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//修改支付方式
- (void) updateCasePayment: (CaseEntity *) caseEntity param:(NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//添加需求商品
- (void) addCaseGoods: (CaseEntity *) caseEntity success: (SuccessBlock) success failure: (FailedBlock) failure;

//编辑需求商品
- (void) editCaseGoods: (CaseEntity *) caseEntity success: (SuccessBlock) success failure: (FailedBlock) failure;

//添加需求服务
- (void) addCaseServices: (CaseEntity *) caseEntity success: (SuccessBlock) success failure: (FailedBlock) failure;

//编辑需求服务
- (void) editCaseServices: (CaseEntity *) caseEntity success: (SuccessBlock) success failure: (FailedBlock) failure;


@end