//
//  UIView+Xml.h
//  Framework
//
//  Created by wuyong on 16/1/20.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//视图初始化成功回调
typedef void (^ViewXmlCallback)(UIView *view);

@interface UIView (Xml)

//开关缓存(Css缓存，页面缓存)
+ (void)xmlCacheEnabled:(BOOL)enabled;

//创建相关
+ (UIView *)viewWithString:(NSString *)string;

+ (UIView *)viewWithString:(NSString *)string basePath:(NSString *)basePath;

+ (UIView *)viewWithFile:(NSString *)file;

+ (UIView *)viewWithName:(NSString *)name;

+ (void)viewWithUrl:(NSString *)url callback:(ViewXmlCallback)callback;

//路径相关
+ (NSString *)getRootPath:(NSString *)path;

+ (NSString *)getBasePath:(NSString *)path;

+ (NSString *)joinPath:(NSString *)basePath path:(NSString *)path;

@end
