//
//  HelperHandler.m
//  LttMember
//
//  Created by wuyong on 15/6/26.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HelperHandler.h"

@implementation HelperHandler

- (void)queryLocation:(LocationEntity *)location success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[LocationEntity class] mappingParam:@{@"address": @"address", @"detail_address":@"detailAddress", @"city": @"city"}];
    
    NSDictionary *param = @{@"lat":location.latitude, @"lon":location.longitude};
    [sharedClient getObject:[LocationEntity new] path:@"location/address" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        //处理city名称，去掉最后的市
        if ([result count] > 0) {
            LocationEntity *entity = [result firstObject];
            if (entity.city && entity.city.length > 0) {
                if ([[entity.city substringFromIndex:(entity.city.length - 1)] isEqualToString:@"市"]) {
                    entity.city = [entity.city substringToIndex:entity.city.length - 1];
                }
            }
        }
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)queryServiceNumber:(LocationEntity *)location success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[LocationEntity class] mappingParam:@{@"service_numbers": @"serviceNumber"}];
    
    NSString *locationStr = [NSString stringWithFormat:@"%f,%f", [location.longitude floatValue], [location.latitude floatValue]];
    NSDictionary *param = @{@"location":locationStr};
    [sharedClient getObject:[LocationEntity new] path:@"service/numbers" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)queryAreas:(AreaEntity *)area success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[AreaEntity class] mappingParam:@{@"area_code": @"code", @"area_name": @"name"}];
    
    NSString *restPath = [sharedClient formatPath:@"area/children/:code" object:area];
    [sharedClient getObject:[AreaEntity new] path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

//发送校验码
- (void) sendMobileCode:(NSString *)mobile success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [NSString stringWithFormat:@"sendSmsCode/%@", mobile];
    [sharedClient getObject:[ResultEntity new] path:restPath param:nil success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

//校验码验证
- (void) verifyMobileCode:(NSString *)mobile code:(NSString *)code success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[ResultEntity class] mappingParam:@{@"vCode": @"data"}];
    
    NSDictionary *param = @{@"code": (code ? code : @"")};
    
    NSString *restPath = [NSString stringWithFormat:@"verifySmsCode/%@", mobile];
    [sharedClient postObject:[ResultEntity new] path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        failure(error);
    }];
}

//检查手机号是否存在
- (void) checkMobile:(NSString *)mobile success:(SuccessBlock)success failure:(FailedBlock)failure {
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[ResultEntity class] mappingParam:@{@"result": @"data"}];

    NSString *restPath = [NSString stringWithFormat:@"user/mobilecheck/%@", mobile];
    [sharedClient getObject:[ResultEntity new] path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        failure(error);
    }];
}

//重置密码
- (void) resetPassword:(UserEntity *)user vCode:(NSString *)vCode success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    NSDictionary *param = @{@"newPass":(user.password ? user.password : @""),@"vCode":(vCode ? vCode : @"")};
    
    NSString * restPath = [NSString stringWithFormat:@"user/password/%@",user.mobile];
    [sharedClient postObject:[RestKitUtil new] path:restPath param:param success:^(NSArray *result) {
        success(result);
    } failure:^(ErrorEntity *error) {
        failure(error);
    }];
}

@end
