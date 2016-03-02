//
//  BusinessHandler.h
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "BusinessEntity.h"

@interface BusinessHandler : BaseHandler

- (void) queryBusiness: (BusinessEntity *) businessEntity success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryBusinessList: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
