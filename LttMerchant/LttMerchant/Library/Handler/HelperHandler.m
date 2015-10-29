//
//  HelperHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/6/26.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HelperHandler.h"

@implementation HelperHandler

//检查手机号是否存在
- (void) checkMobile:(NSString *)mobile success:(SuccessBlock)success failure:(FailedBlock)failure {
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[ResultEntity class] mappingParam:@{@"result": @"data"}];
    
    NSDictionary *param = @{@"user_type":@"merchant"};
    
    NSString *restPath = [NSString stringWithFormat:@"user/mobilecheck/%@", mobile];
    [sharedClient getObject:[ResultEntity new] path:restPath param:param success:^(NSArray *result){
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

//验证校验码
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

//重置密码
- (void) resetPassword:(UserEntity *) user vCode:(NSString *)vCode success:(SuccessBlock)success failure:(FailedBlock)failure
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
