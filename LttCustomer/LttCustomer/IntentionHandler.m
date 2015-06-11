//
//  IntentionHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "IntentionHandler.h"

@implementation IntentionHandler

- (void) addIntention:(IntentionEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[IntentionEntity class] mappingParam:@{@"brandId": @"brand_id", @"remark": @"remark", @"categoryId": @"category_id", @"location": @"location", @"modelId" :@"model_id"}];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[IntentionEntity class] mappingParam:@{@"intention_id": @"id"}];
    
    [sharedClient putObject:intention path:@"intention/info" param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryIntention:(IntentionEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[IntentionEntity class] mappingParam:@{@"brand_name": @"brandName", @"create_time": @"createTime", @"employee_id": @"employeeId", @"employee_mobile":@"employeeMobile", @"employee_name": @"employeeName", @"intention_id":@"id", @"intention_status":@"status", @"model_name":@"modelName", @"order_no":@"orderNo", @"remark":@"remark", @"response_status": @"responseStatus", @"response_time":@"responseTime", @"user_id":@"userId", @"user_mobile":@"userMobile", @"user_name":@"userName"}];
    
    NSString *restPath = [sharedClient formatPath:@"intention/info/:id" object:intention];
    [sharedClient getObject:intention path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

@end
