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
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[UserEntity class] mappingParam:@{@"user_id": @"id", @"user_truename":@"name", @"user_token":@"token", @"user_nickname":@"nickname",@"sex": @"sexAlias"}];
    
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

- (void)addAddress:(AddressEntity *)address success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[AddressEntity class] mappingParam:@{@"isDefault": @"is_default", @"provinceId": @"province_code", @"cityId": @"city_code", @"countyId":@"area_code", @"streetId": @"street_code", @"mobile":@"mobile", @"name":@"truename", @"address":@"address"}];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[AddressEntity class] mappingParam:@{@"address_id": @"id"}];
    
    [sharedClient putObject:address path:@"member/address" param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)editAddress:(AddressEntity *)address success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[AddressEntity class] mappingParam:@{@"isDefault": @"is_default", @"provinceId": @"province_code", @"cityId": @"city_code", @"countyId":@"area_code", @"streetId": @"street_code", @"mobile":@"mobile", @"name":@"truename", @"address":@"address"}];
    
    NSString *restPath = [sharedClient formatPath:@"member/address/:id" object:address];
    [sharedClient postObject:address path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        failure(error);
    }];
}

- (void)deleteAddress:(AddressEntity *)address success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [[RestKitUtil sharedClient] formatPath:@"member/address/:id" object:address];
    [sharedClient deleteObject:address path:restPath param:nil success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void)queryAddress:(AddressEntity *)address success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[AddressEntity class] mappingParam:@{@"address_id": @"id", @"address":@"address", @"area":@"countyName", @"area_code":@"countyId", @"city":@"cityName",@"city_code":@"cityId",@"is_default":@"isDefault",@"mobile":@"mobile",@"province":@"provinceName", @"province_code":@"provinceId",@"street":@"streetName", @"street_code":@"streetId", @"truename":@"name"}];
    
    NSString *restPath = [sharedClient formatPath:@"member/address/:id" object:address];
    [sharedClient getObject:address path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryUserAddresses:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[AddressEntity class] mappingParam:@{@"address_id": @"id", @"address":@"address", @"area":@"countyName", @"area_code":@"countyId", @"city":@"cityName",@"city_code":@"cityId",@"is_default":@"isDefault",@"mobile":@"mobile",@"province":@"provinceName", @"province_code":@"provinceId",@"street":@"streetName", @"street_code":@"streetId", @"truename":@"name"} keyPath:@"list"];
    
    NSString *restPath = @"member/addresses";
    [sharedClient getObject:[AddressEntity new] path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) editUser:(UserEntity *)user success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[UserEntity class] mappingParam:@{@"nickname": @"nickname", @"sexAlias": @"sex"}];
    
    NSString *restPath = [sharedClient formatPath:@"member/info/:id" object:user];
    [sharedClient postObject:user path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        failure(error);
    }];
}

- (void) changePassword:(UserEntity *)user password:(NSString *)password success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSDictionary *param = @{@"newpass":(password ? password : @""), @"password":(user.password ? user.password : @""), @"type":@"modify"};
    
    NSString *restPath = [sharedClient formatPath:@"user/passport/:id" object:user];
    [sharedClient postObject:[UserEntity new] path:restPath param:param success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void)addSuggestion:(NSString *)suggestion success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSDictionary *param = @{@"contents":(suggestion ? suggestion : @"")};
    
    [sharedClient putObject:[UserEntity new] path:@"member/suggestion" param:param success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
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
