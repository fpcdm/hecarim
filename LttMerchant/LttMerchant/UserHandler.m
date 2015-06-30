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
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[UserEntity class] mappingParam:@{@"user_id": @"id", @"user_truename":@"name", @"user_token":@"token"}];
    
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

- (void)addDevice:(DeviceEntity *)device success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[DeviceEntity class] mappingParam:@{@"app": @"app", @"token": @"device_token", @"type": @"device_type"}];
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

@end
