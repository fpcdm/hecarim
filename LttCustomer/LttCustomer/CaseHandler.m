//
//  IntentionHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseHandler.h"

@implementation CaseHandler

- (void) addIntention:(CaseEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[CaseEntity class] mappingParam:@{@"type": @"type", @"remark": @"remark", @"location": @"location"}];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[CaseEntity class] mappingParam:@{@"intention_id": @"id"}];
    
    [sharedClient putObject:intention path:@"cases/info" param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryIntention:(CaseEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[CaseEntity class] mappingParam:@{@"create_time": @"createTime", @"employee_id": @"employeeId", @"employee_mobile":@"employeeMobile", @"employee_name": @"employeeName", @"employee_avatar": @"employeeAvatar", @"intention_id":@"id", @"intention_status":@"status", @"order_no":@"orderNo", @"remark":@"remark", @"response_status": @"responseStatus", @"response_time":@"responseTime", @"user_id":@"userId", @"user_mobile":@"userMobile", @"user_name":@"userName"}];
    
    NSString *restPath = [sharedClient formatPath:@"cases/info/:id" object:intention];
    [sharedClient getObject:intention path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryIntentions:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[CaseEntity class] mappingParam:@{@"case_id": @"id", @"case_no": @"orderNo", @"create_time": @"createTime", @"status":@"status", @"detail": @"details",@"remark":@"remark"} keyPath:@"list"];
    
    NSString *restPath = @"cases/list";
    [sharedClient getObject:[CaseEntity new] path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) cancelIntention:(CaseEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [[RestKitUtil sharedClient] formatPath:@"cases/info/:id" object:intention];
    [sharedClient deleteObject:intention path:restPath param:nil success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

@end
