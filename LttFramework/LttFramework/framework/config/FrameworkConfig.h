//
//  FrameworkConfig.h
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#ifndef LttFramework_FrameworkConfig_h
#define LttFramework_FrameworkConfig_h


#pragma mark - 环境切换
/********环境切换>>>********/
//开发模式
#define LTT_DEBUG

//切换到正式环境
//#undef LTT_DEBUG
/********<<<环境切换********/


#pragma mark - 环境配置
#ifdef LTT_DEBUG
/********开发环境>>>********/
//调试判断变量
#define IS_DEBUG YES

//DDLog调试级别，需要安装XcodeColors
#define LOG_LEVEL_DEF DDLogLevelAll

//开发调试函数
#if TARGET_IPHONE_SIMULATOR
#define NSLog(...) DDLogVerbose(__VA_ARGS__);
#endif

//接口服务器根地址
#define LTT_REST_SERVER @"http://maokai.web.dm/"

//接口服务器是否为RAP
#define LTT_REST_RAP NO
/********>>>开发环境********/
#else
/********正式环境>>>********/
//调试判断变量
#define IS_DEBUG NO

//关闭调试，需要安装XcodeColors
#define LOG_LEVEL_DEF DDLogLevelOff

//关闭NSLog
#define NSLog(...)

//接口服务器根地址
#define LTT_REST_SERVER @"http://maokai.lttok.com/"

//接口服务器是否为RAP
#define LTT_REST_RAP NO
/********>>>正式环境********/
#endif


#pragma mark - 公用配置
/********公用配置>>>********/
//加载本地化文件
#import "LocaleUtil.h"

//加载日志插件
#import "CocoaLumberjack.h"

//定义弹出框停留时间
#define DIALOG_SHOW_TIME 2.0
//定义成功框显示时间
#define LOADING_SUCCESS_TIME 0.5

//系统错误配置
#define ERROR_CODE_NETWORK 101
#define ERROR_CODE_API 102
#define ERROR_CODE_JSON 103
#define ERROR_CODE_NOLOGIN 1000
#define ERROR_CODE_NOAUTH 4000

//通知信息KEY
#define NOTIFICATION_USERINFO_KEY @""

//表格默认配置
#define CELL_REUSE_IDENTIFIER_DEFAULT @"cellIdentifier"
//UITableViewStyleGrouped时0不会生效，必须大于0
#define HEIGHT_TABLE_MARGIN_ZERO 0.01
#define HEIGHT_TABLE_MARGIN_DEFAULT 10
#define HEIGHT_TABLE_SECTION_HEADER_DEFAULT HEIGHT_TABLE_MARGIN_ZERO
#define HEIGHT_TABLE_SECTION_FOOTER_DEFAULT HEIGHT_TABLE_MARGIN_DEFAULT
#define HEIGHT_TABLE_CELL_DEFAULT 45
#define HEIGHT_TABLE_HEADER_DEFAULT HEIGHT_TABLE_MARGIN_ZERO
#define HEIGHT_TABLE_FOOTER_DEFAULT HEIGHT_TABLE_MARGIN_ZERO
#define FONT_TABLE_CELL_DEFAULT 16
#define FONT_TABLE_CELL_DETAIL_DEFAULT 16

//CollectionView默认配置
#define SIZE_COLLECTION_CELL_DEFAULT CGSizeMake(50, 50)
#define INSET_COLLECTION_SECTION_DEFAULT UIEdgeInsetsMake(10, 10, 10, 10)
#define FONT_COLLECTION_CELL_DEFAULT 16
/********<<<公用配置********/


/********系统定义>>>********/
#pragma mark - 系统常量
//屏幕尺寸常量
#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define SCREEN_NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define SCREEN_AVAILABLE_HEIGHT (SCREEN_HEIGHT - SCREEN_STATUSBAR_HEIGHT - SCREEN_NAVIGATIONBAR_HEIGHT)

// 判断ios系统版本，不能用于宏判断
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
// 判断是否大于等于ios8
#define IS_IOS8_PLUS (IOS_VERSION >= 8.0 ? YES : NO)
// 判断是否大于等于ios7
#define IS_IOS7_PLUS (IOS_VERSION >= 7.0 ? YES : NO)
// 判断是否大于等于ios6
#define IS_IOS6_PLUS (IOS_VERSION >= 6.0 ? YES : NO)
// 判断是否是ios6系统
#define IS_IOS6 (IOS_VERSION >= 6.0 && IOS_VERSION < 7.0 ? YES : NO)
// 是否大于等于iPhone5(屏幕尺寸)
#define IS_IPHONE5_PLUS (SCREEN_HEIGHT >= 568.0 ? YES : NO)

//设备类型
#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad   ? YES : NO)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? YES : NO)
#define IS_RETINA ([[UIScreen mainScreen] scale] > 1 ? YES : NO)

//判断是否是模拟器
#if TARGET_IPHONE_SIMULATOR
#define IS_IPHONE_SIMULATOR YES
#define IS_IPHONE_OS NO
#else
#define IS_IPHONE_SIMULATOR NO
#define IS_IPHONE_OS YES
#endif

//判断SDK版本
#ifndef __IPHONE_6_0
#error "SDK版本过低，必须IOS SDK 6.0以上"
#endif

//修正ios6表格数据异常
#ifndef __IPHONE_7_0
#import "UITableViewCell+AutoLayoutFix.h"
#endif

#pragma mark - 方法定义
//本地化字符串方法
#define LocalString(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"InfoPlist"]
/********<<<系统定义********/


#endif
