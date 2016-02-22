//
//  FWHelperSystem.h
//  Framework
//
//  Created by 吴勇 on 16/2/22.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWHelperSystem : NSObject

//获取Bundle版本
+ (NSString *)bundleVersion;

//获取Bundle短版本
+ (NSString *)bundleShortVersion;

//获取Bundle标识
+ (NSString *)bundleIdentifier;

//获取UrlSchema
+ (NSString *)urlSchema;

//根据名字获取UrlSchema
+ (NSString *)urlSchema:(NSString *)name;

//获取UUID
+ (NSString *)identifierUUID;

//判断设备是否越狱
+ (BOOL)isJailbreak;

@end
