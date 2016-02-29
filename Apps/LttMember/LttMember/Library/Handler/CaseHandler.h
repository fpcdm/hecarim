//
//  IntentionHandler.h
//  LttMember
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "CaseEntity.h"
#import "CategoryEntity.h"
#import "PropertyEntity.h"
#import "PaymentEntity.h"

@interface CaseHandler : BaseHandler

//用户收藏的需求类型列表
- (void)queryFavoriteTypes:(NSDictionary *)param success: (SuccessBlock) success failure: (FailedBlock) failure;

//查询未收藏的需求类型列表
- (void)queryUnfavoriteTypes:(NSDictionary *)param success: (SuccessBlock) success failure: (FailedBlock) failure;

//保存收藏的类型列表
- (void)saveFavoriteTypes: (NSArray *) types success: (SuccessBlock) success failure: (FailedBlock) failure;

//需求属性列表
- (void) queryProperties: (CategoryEntity *) type success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) addIntention: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryIntention: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryIntentions: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) cancelIntention: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

//支付方式列表
- (void) queryPayments: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//修改支付方式
- (void) updateCasePayment: (CaseEntity *) intention param:(NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//提交评价
- (void) addIntentionEvaluation: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
