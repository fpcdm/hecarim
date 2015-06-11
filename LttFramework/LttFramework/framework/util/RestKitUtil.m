//
//  RestKitUtil.m
//  LttFramework
//
//  Created by wuyong on 15/6/3.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "RestKitUtil.h"
#import "FrameworkConfig.h"
#import "UserEntity.h"
#import "StorageUtil.h"

static RestKitUtil *sharedClient = nil;

@implementation RestKitUtil
{
    RKObjectManager *manager;
}

#pragma mark - Static Methods
+ (RestKitUtil *) sharedClient
{
    //多线程唯一
    @synchronized(self){
        if (!sharedClient) {
            sharedClient = [[self alloc] init];
        }
    }
    return sharedClient;
}

- (id) init
{
    self = [super init];
    if (self) {
        manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:LTT_REST_SERVER]];
    }
    return self;
}

#pragma mark - Public Methods
- (NSString *) formatPath: (NSString *) path  object: (id) object
{
    NSString *resultPath = RKPathFromPatternWithObject(path, object);
    return resultPath;
}

- (RKRequestDescriptor *) addRequestDescriptor: (Class) objectClass mappingParam: (id) param
{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    if ([param isKindOfClass:[NSDictionary class]]) {
        [requestMapping addAttributeMappingsFromDictionary:param];
    } else {
        [requestMapping addAttributeMappingsFromArray:param];
    }
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:objectClass
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodAny];
    [manager addRequestDescriptor:requestDescriptor];
    
    return requestDescriptor;
}

- (void) removeRequestDescriptor:(RKRequestDescriptor *)requestDescriptor
{
    [manager removeRequestDescriptor:requestDescriptor];
}

- (RKResponseDescriptor *) addResponseDescriptor: (Class) objectClass mappingParam: (id) param
{
    return [self addResponseDescriptor:objectClass mappingParam:param keyPath:nil];
}

- (RKResponseDescriptor *) addResponseDescriptor: (Class) objectClass mappingParam: (id) param keyPath: (NSString *) keyPath
{
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:objectClass];
    if ([param isKindOfClass:[NSDictionary class]]) {
        [responseMapping addAttributeMappingsFromDictionary:param];
    } else {
        [responseMapping addAttributeMappingsFromArray:param];
    }
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:keyPath
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:RKStatusCodeClassSuccessful]];
    [manager addResponseDescriptor:responseDescriptor];
    
    return responseDescriptor;
}

- (void) removeResponseDescriptor:(RKResponseDescriptor *)responseDescriptor
{
    [manager removeResponseDescriptor:responseDescriptor];
}

#pragma mark - REST Methods
- (void) putObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure
{
    path = [self fixPath:path with:@"/put"];
    
    [self addHeader];
    [manager putObject:object path:path parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *result){
        [self success:operation result:result callback:success];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self failure:operation error:error callback:failure];
    }];
}

- (void) deleteObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure
{
    path = [self fixPath:path with:@"/delete"];
    
    //手工合并参数，解决RestKit不合并object参数问题
    param = [self mergeObject:object withParam:param];
    
    [self addHeader];
    [manager deleteObject:object path:path parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *result){
        [self success:operation result:result callback:success];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self failure:operation error:error callback:failure];
    }];
}

- (void) getObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure
{
    path = [self fixPath:path with:@"/get"];
    
    //手工合并参数，解决RestKit不合并object参数问题
    param = [self mergeObject:object withParam:param];
    
    [self addHeader];
    [manager getObject:object path:path parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *result){
        [self success:operation result:result callback:success];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self failure:operation error:error callback:failure];
    }];
}

- (void) postObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure
{
    path = [self fixPath:path with:@"/post"];
    
    [self addHeader];
    [manager postObject:object path:path parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *result){
        [self success:operation result:result callback:success];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self failure:operation error:error callback:failure];
    }];
}

#pragma mark - Private Methods
//手工合并参数，解决RestKit使用GET和DELETE时不会自动合并参数，导致参数传递不过去的问题
- (NSDictionary *) mergeObject: (id) object withParam: (NSDictionary *) param
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    //只支持BaseEntity
    if (object && [object isKindOfClass:[BaseEntity class]]) {
        [dictParam setDictionary:[(BaseEntity*) object toDictionary]];
    }
    if (param) {
        [dictParam setDictionary:param];
    }
    
    return dictParam;
}

- (NSString *) fixPath: (NSString *) path with: (NSString *) fix
{
    if (LTT_REST_RAP) {
        path = [path stringByAppendingString:fix];
    }
    return path;
}

//添加token和user_type
- (void) addHeader
{
    //获取token
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (user) {
        [manager.HTTPClient setDefaultHeader:@"Token" value:user.token];
        [manager.HTTPClient setDefaultHeader:@"User-Type" value:user.type];
    }
}

- (void) success: (RKObjectRequestOperation *) operation result:(RKMappingResult *) result callback: (void (^)(NSArray *result)) callback
{
    NSArray *array = [result array];
    
    NSLog(@"success:%@", array);
    
    callback(array);
}

- (void) failure: (RKObjectRequestOperation *) operation error:(NSError *) error callback: (void (^)(ErrorEntity *error)) callback
{
    ErrorEntity *errorModel = [[ErrorEntity alloc] init];
    
    NSData *data = operation.HTTPRequestOperation.responseData;
    if (data == nil) {
        errorModel.code = ERROR_CODE_NETWORK;
        errorModel.message = ERROR_MESSAGE_NETWORK;
    } else {
        NSError *jsonError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        if (json == nil) {
            errorModel.code = ERROR_CODE_JSON;
            errorModel.message = ERROR_MESSAGE_JSON;
        } else {
            id error_code = [json valueForKey:@"error_code"];
            id error_msg = [json objectForKey:@"error"];
            errorModel.code = error_code ? [error_code integerValue] : ERROR_CODE_API;
            errorModel.message = error_msg ? (NSString *) error_msg : ERROR_MESSAGE_API;
        }
    }
    
    NSLog(@"failure: %li %@", errorModel.code, errorModel.message);
    
    callback(errorModel);
}

#pragma mark - Test Methods
- (void) test
{
    [self addRequestDescriptor:[UserEntity class] mappingParam:@[@"mobile", @"password", @"type"]];
    [self addResponseDescriptor:[UserEntity class] mappingParam:@{@"user_id": @"id", @"user_truename":@"name"}];
    
    // Work with the object
    UserEntity *user = [UserEntity new];
    user.mobile = @"18875001455";
    user.password = @"123456";
    user.type = @"merchant";
    
    NSDictionary *param = nil;
    
    // PUT
    /*
     [self putObject:user path:@"user" param:param success:^(NSArray *result){
     
     } failure:^(NSDictionary *error){
     
     }];
     */
    
    // GET
    [self getObject:user path:@"user/passport" param:param success:^(NSArray *result){
        UserEntity *user = [result firstObject];
        NSLog(@"user:%@", user);
        NSLog(@"user:%@, %@", user.id, user.name);
        
    } failure:^(ErrorEntity *error){
        
    }];
    
    // POST
    /*
     [self postObject:user path:@"user" param:param success:^(NSArray *result){
     
     } failure:^(ErrorModel *error){
     
     }];
     */
    
    // DELETE
    /*
     [self deleteObject:user path:@"user" param:param success:^(NSArray *result){
     
     } failure:^(ErrorModel *error){
     
     }];
     */
}

@end
