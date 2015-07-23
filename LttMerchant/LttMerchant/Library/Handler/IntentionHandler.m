//
//  IntentionHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "IntentionHandler.h"

@implementation IntentionHandler

- (void) queryCases:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[IntentionEntity class] mappingParam:@{@"case_id": @"id", @"case_no": @"orderNo", @"create_time": @"createTime", @"status":@"status", @"contact": @"userName", @"contact_mobile":@"userMobile"} keyPath:@"list"];
    
    NSString *restPath = @"employee/cases";
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
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[IntentionEntity class] mappingParam:@{@"remark": @"remark", @"intention_id":@"id"}];
    
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
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[IntentionEntity class] mappingParam:@{@"create_time": @"createTime", @"employee_id": @"employeeId", @"employee_mobile":@"employeeMobile", @"employee_name": @"employeeName", @"intention_id":@"id", @"intention_status":@"status", @"order_no":@"orderNo", @"remark":@"remark", @"response_status": @"responseStatus", @"response_time":@"responseTime", @"user_id":@"userId", @"user_mobile":@"userMobile", @"user_name":@"userName", @"buyer_address":@"address"}];
    
    NSString *restPath = [sharedClient formatPath:@"cases/info/:id" object:intention];
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
