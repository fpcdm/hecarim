//
//  RestKitUtil.h
//  LttFramework
//
//  Created by wuyong on 15/6/3.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "ErrorEntity.h"
#import "FileEntity.h"

//全局错误代码块：可统一处理错误事件，如未登录等
//返回YES代表继续执行自定义错误事件，NO则中断
typedef BOOL (^RestKitGlobalErrorBlock)(ErrorEntity *error);

//RestKit成功回调代码块
typedef void (^RestKitSuccessBlock)(NSArray *result);

//RestKit失败回调代码块
typedef void (^RestKitErrorBlock)(ErrorEntity *error);

@interface RestKitUtil : NSObject

@property (copy) RestKitGlobalErrorBlock globalErrorBlock;

+ (RestKitUtil *) sharedClient;

- (void) setClientType: (NSString *) clientType;

- (NSString *) formatPath: (NSString *) path  object: (id) object;

- (RKRequestDescriptor *) addRequestDescriptor: (Class) objectClass mappingParam: (id) param;

- (void) removeRequestDescriptor: (RKRequestDescriptor *) requestDescriptor;

- (RKResponseDescriptor *) addResponseDescriptor: (Class) objectClass mappingParam: (id) param;

- (RKResponseDescriptor *) addResponseDescriptor: (Class) objectClass mappingParam: (id) param keyPath: (NSString *) keyPath;

- (void) removeResponseDescriptor: (RKResponseDescriptor *) responseDescriptor;

- (void) putObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure;

- (void) postObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure;

- (void) deleteObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure;

- (void) getObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure;

- (void) postFile: (FileEntity *) file path: (NSString *) path param: (NSDictionary *) param success: (RestKitSuccessBlock) success failure: (RestKitErrorBlock) failure;

- (void) test;

@end
