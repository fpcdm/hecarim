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

- (void) updateCaseStatus: (CaseEntity *) caseEntity param: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

@end