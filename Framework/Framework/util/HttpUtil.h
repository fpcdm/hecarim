//
//  HttpUtil.h
//  Framework
//
//  Created by wuyong on 16/1/20.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求成功回调
typedef void (^HttpUtilCallback)(NSData *data);

typedef enum {
    HttpUtilMethodGet = 0,
    HttpUtilMethodPost
} HttpUtilMethod;

@interface HttpUtil : NSObject

+ (NSString *)getRootPath:(NSString *)path;

+ (NSString *)getBasePath:(NSString *)path;

+ (NSString *)joinPath:(NSString *)basePath path:(NSString *)path;

+ (BOOL)isUrl:(NSString *)url;

+ (BOOL)isHtml:(NSString *)str;

+ (void)get:(NSString *)url params:(id)params callback:(HttpUtilCallback)callback;

+ (void)post:(NSString *)url params:(id)params callback:(HttpUtilCallback)callback;

+ (void)request:(NSString *)url params:(id)params headers:(NSDictionary *)headers method:(HttpUtilMethod)method callback:(HttpUtilCallback)callback;

@end
