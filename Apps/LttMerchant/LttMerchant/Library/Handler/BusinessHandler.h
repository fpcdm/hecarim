//
//  BusinessHandler.h
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "ResultEntity.h"
#import "BusinessEntity.h"

@interface BusinessHandler : BaseHandler

/**
 * 获取用户开通的服务列表
 *
 */
- (void)getUserServicesList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

//添加生意圈信息
- (void)addBusiness:(BusinessEntity *)business param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

//获取生意圈列表
- (void)getBusinessList:(BusinessEntity *)business param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

//获取生意圈详情
- (void)getBusinessDetail:(BusinessEntity *)business param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

//删除
- (void)deleteBusiness:(BusinessEntity *)business param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

@end
