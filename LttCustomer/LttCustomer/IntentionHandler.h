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

- (void) addIntention: (IntentionEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryIntention: (IntentionEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
