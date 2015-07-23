//
//  IntentionHandler.h
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "IntentionEntity.h"

@interface IntentionHandler : BaseHandler

- (void) queryCases: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//抢单
- (void) competeIntention: (IntentionEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryIntention: (IntentionEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

//弃单
- (void) giveupIntention: (IntentionEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
