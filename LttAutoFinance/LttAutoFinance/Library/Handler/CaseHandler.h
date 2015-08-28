//
//  IntentionHandler.h
//  LttAutoFinance
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "CaseEntity.h"
#import "CategoryEntity.h"

@interface CaseHandler : BaseHandler

//需求类型列表
- (void) queryTypes:(NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) addIntention: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryIntention: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryIntentions: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) cancelIntention: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) updateIntentionStatus: (CaseEntity *) intention param: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//提交评价
- (void) addIntentionEvaluation: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
