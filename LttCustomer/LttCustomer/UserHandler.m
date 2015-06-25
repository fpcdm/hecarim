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
    
    [sharedClient getObject:user path:@"user/passport" param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)queryLocation:(LocationEntity *)location success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[LocationEntity class] mappingParam:@{@"address": @"address"}];
    
    NSDictionary *param = @{@"lat":location.latitude, @"lon":location.longitude};
    [sharedClient getObject:[LocationEntity new] path:@"location/address" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
    
}

@end
