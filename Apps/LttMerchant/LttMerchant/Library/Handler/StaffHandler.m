//
//  StaffHandler.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/30.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "StaffHandler.h"

@implementation StaffHandler

//检查用户权限
- (void)userPermissions:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[StaffEntity class] mappingParam:@{@"is_admin": @"is_admin",@"is_merchant": @"isMerchant"}];
    
    [sharedClient getObject:[StaffEntity new] path:@"user/permissions" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

//获取员工列表
- (void)getStaffList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[StaffEntity class] mappingParam:@{@"staff_staff_id" : @"id",@"staff_truename" : @"name"} keyPath:@"list"];
    
    [sharedClient getObject:[StaffEntity new] path:@"staff/list" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];

}

//添加员工
- (void)addStaff:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[ResultEntity class] mappingParam:@{@"staff_status" : @"data"}];
    
    [sharedClient putObject:[ResultEntity new] path:@"staff/add" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

//员工详情
- (void)staffDetail:(StaffEntity *)staff param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[StaffEntity class] mappingParam:@{
                    @"staff_staff_id" : @"id",
                    @"staff_code"     : @"no",
                    @"staff_truename" : @"name",
                    @"staff_nickname" : @"nickname",
                    @"staff_mobile"   : @"mobile",
                    @"staff_img"      : @"avatar"
                    }];
    NSString *restPath = [sharedClient formatPath:@"staff/info/:id" object:staff];
    
    [sharedClient getObject:[StaffEntity new] path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)editStaff:(StaffEntity *)staffEntity param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [sharedClient formatPath:@"staff/modify/:id" object:staffEntity];
    
    [sharedClient postObject:staffEntity path:restPath param:param success:^(NSArray *result){
        
        success(result);
    } failure:^(ErrorEntity *error){
        
        failure(error);
    }];

}

- (void) uploadAvatar:(FileEntity *)avatar success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[FileEntity class] mappingParam:@{@"image_url": @"url"}];
    
    
    NSString *restPath = [sharedClient formatPath:@"user/avatar/:id" object:avatar];
    
    [sharedClient postFile:avatar path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)resetStaffPassword:(StaffEntity *)staff param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [sharedClient formatPath:@"user/passport/:id" object:staff];
    
    [sharedClient postObject:staff path:restPath param:param success:^(NSArray *result){
        
        success(result);
    } failure:^(ErrorEntity *error){
        
        failure(error);
    }];
}

@end
