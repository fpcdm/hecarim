//
//  IntentionHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "IntentionHandler.h"

@implementation IntentionHandler

- (void) queryIntentions:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[IntentionEntity class] mappingParam:@{@"brand_name": @"brandName", @"model_name": @"modelName", @"remark": @"remark", @"intention_id":@"id"} keyPath:@"list"];
    
    NSString *restPath = @"employee/intentions";
    [sharedClient getObject:[IntentionEntity new] path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) competeIntention:(IntentionEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[IntentionEntity class] mappingParam:@{@"brand_name": @"brandName", @"model_name": @"modelName", @"remark": @"remark", @"intention_id":@"id"}];
    
    NSString *restPath = [[RestKitUtil sharedClient] formatPath:@"employee/response/:id" object:intention];
    [sharedClient putObject:intention path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryIntention:(IntentionEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[IntentionEntity class] mappingParam:@{@"brand_name": @"brandName", @"create_time": @"createTime", @"employee_id": @"employeeId", @"employee_mobile":@"employeeMobile", @"employee_name": @"employeeName", @"intention_id":@"id", @"intention_status":@"status", @"model_name":@"modelName", @"order_no":@"orderNo", @"remark":@"remark", @"response_status": @"responseStatus", @"response_time":@"responseTime", @"user_id":@"userId", @"user_mobile":@"userMobile", @"user_name":@"userName",@"category_id":@"categoryId"}];
    
    NSString *restPath = [sharedClient formatPath:@"intention/info/:id" object:intention];
    [sharedClient getObject:intention path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) giveupIntention:(IntentionEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [[RestKitUtil sharedClient] formatPath:@"employee/response/:id" object:intention];
    [sharedClient deleteObject:intention path:restPath param:nil success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

@end
