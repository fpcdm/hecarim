//
//  FWDefine.h
//  Framework
//
//  Created by 吴勇 on 16/2/14.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#ifndef FWDefine_h
#define FWDefine_h


#pragma mark - 环境切换
/********环境切换>>>********/
//调试Xcode变量，Xcode自动根据Debug和Release环境生成
#ifdef DEBUG

//调试自定义变量，项目建议使用此变量区分环境
#define APP_DEBUG

#endif

//定义开关
#define __ON__    (1)
#define __OFF__   (0)
#ifdef APP_DEBUG
#define __AUTO__  (1)
#else
#define __AUTO__  (0)
#endif
/********<<<环境切换********/


#pragma mark - 功能开关
/********功能开关>>>********/


#ifdef APP_DEBUG

//调试开关
#define FRAMEWORK_DEBUG (1)
//测试开关
#define FRAMEWORK_TEST  (1)
//日志开关
#define FRAMEWORK_LOG   (1)

//日志级别
#define FRAMEWORK_LOG_LEVEL FWLogLevelAll

#else

//调试开关
#define FRAMEWORK_DEBUG (0)
//测试开关
#define FRAMEWORK_TEST  (0)
//日志开关
#define FRAMEWORK_LOG   (0)

//日志级别
#define FRAMEWORK_LOG_LEVEL FWLogLevelOff

#endif
/********<<<功能开关********/


#pragma mark - 环境配置
#ifdef APP_DEBUG
/********开发环境>>>********/
//是否是开发环境，项目建议使用此变量判断环境
#define IS_DEBUG YES

//是否是正式环境，项目建议使用此变量判断环境
#define IS_RELEASE NO
/********>>>开发环境********/
#else
/********正式环境>>>********/
//是否是开发环境，项目建议使用此变量判断环境
#define IS_DEBUG NO

//是否是正式环境，项目建议使用此变量判断环境
#define IS_RELEASE YES

//关闭NSLog
#define NSLog(...)
/********>>>正式环境********/
#endif

//判断是否是模拟器
#if TARGET_OS_SIMULATOR
/********开发环境>>>********/
#define IS_SIMULATOR YES
/********>>>开发环境********/
#else
/********正式环境>>>********/
#define IS_SIMULATOR NO
/********>>>正式环境********/
#endif


/********系统定义>>>********/
#pragma mark - 系统常量
//屏幕尺寸常量
#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
//导航和TabBar高度常量与hidden属性无关
#define NAVIGATIONBAR_HEIGHT [FWScreen sharedInstance].navigationBarHeight
#define TABBAR_HEIGHT [FWScreen sharedInstance].tabBarHeight

//设备类型
#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad   ? YES : NO)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? YES : NO)

// 判断ios系统版本，不能用于宏判断
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
// 判断是否大于等于版本
#define IS_IOS9P (IOS_VERSION >= 9.0 ? YES : NO)
#define IS_IOS8P (IOS_VERSION >= 8.0 ? YES : NO)
#define IS_IOS7P (IOS_VERSION >= 7.0 ? YES : NO)
// 判断是否是某版本
#define IS_IOS9 (IOS_VERSION >= 9.0 && IOS_VERSION < 10.0 ? YES : NO)
#define IS_IOS8 (IOS_VERSION >= 8.0 && IOS_VERSION < 9.0 ? YES : NO)
#define IS_IOS7 (IOS_VERSION >= 7.0 && IOS_VERSION < 8.0 ? YES : NO)

//判断屏幕尺寸，是否是3.5英寸屏幕
#define IS_SCREEN35 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//是否是4.0英寸屏幕
#define IS_SCREEN40 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//是否是4.7英寸屏幕
#define IS_SCREEN47 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//是否是5.5英寸屏幕
#define IS_SCREEN55 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//判断SDK版本
#ifndef __IPHONE_7_0
#error "SDK版本过低，必须IOS SDK 7.0以上"
#endif
/********<<<系统定义********/


#endif /* FWDefine_h */
