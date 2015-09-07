//
//  UserHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/5/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "UserHandler.h"

@implementation UserHandler

- (void) loginWithUser:(UserEntity *)user success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[UserEntity class] mappingParam:@{@"user_id": @"id", @"user_truename":@"name", @"user_token":@"token", @"user_nickname":@"nickname",@"user_sex": @"sexAlias", @"user_avatar":@"avatar"}];
    
    //映射device_id和device_type
    NSDictionary *param = @{@"device_id":user.deviceId ? user.deviceId : @"", @"device_type":user.deviceType ? user.deviceType : @""};
    
    [sharedClient getObject:user path:@"user/passport" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)logoutWithUser:(UserEntity *)user success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    [sharedClient deleteObject:[UserEntity new] path:@"user/passport" param:nil success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void)updateHeartbeat:(UserEntity *)user param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    [sharedClient postObject:user path:@"user/heartbeat" param:param success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void)addDevice:(DeviceEntity *)device success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[DeviceEntity class] mappingParam:@{@"token": @"device_token", @"type": @"device_type"}];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[DeviceEntity class] mappingParam:@{@"device_id": @"id"}];
    
    [sharedClient putObject:device path:@"base/device" param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)clearNotifications:(DeviceEntity *)device success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [[RestKitUtil sharedClient] formatPath:@"base/badge/:id" object:device];
    [sharedClient deleteObject:device path:restPath param:nil success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void) queryConsumeHistory:(UserEntity *)user param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[ConsumeEntity class] mappingParam:@{@"consum_time": @"consumeTime", @"content": @"consumeContent"} keyPath:@"list"];
    
    NSString *restPath = [sharedClient formatPath:@"member/consumptions/:id" object:user];
    [sharedClient getObject:user path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

@end
