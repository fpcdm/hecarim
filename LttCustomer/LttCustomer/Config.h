//
//  应用配置文件，包含此文件即可
//  Config.h
//  LttCustomer
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#ifndef LttCustomer_Config_h
#define LttCustomer_Config_h


#pragma mark - 框架配置
/********框架配置>>>********/
#import "FrameworkConfig.h"
/********<<<框架配置********/


#pragma mark - 环境配置
/********加载环境配置>>>********/
//环境配置
#ifdef LTT_DEBUG
#import "Config_debug.h"
#else
#import "Config_product.h"
#endif

//系统配置
#import "UIColor+Hex.h"
#import "NSString+trim.h"
#import "UITextView+Placeholder.h"
/********>>>加载环境配置********/


#pragma mark - 公用配置
/********公用配置>>>********/
//用户登录类型
#define USER_TYPE_MEMBER @"member"

//客服电话
#define LTT_CUSTOMER_SERVICE @"400-820-5555"

//需求状态
#define INTENTION_STATUS_NEW @"new"
#define INTENTION_STATUS_LOCKED @"locked"
#define INTENTION_STATUS_SUCCESS @"success"
#define INTENTION_STATUS_FAIL @"fail"

//响应状态
#define RESPONSE_STATUS_NEW @"new"
#define RESPONSE_STATUS_SUCCESS @"success"
#define RESPONSE_STATUS_FAIL @"fail"

//订单状态
#define ORDER_STATUS_NEW @"new"
#define ORDER_STATUS_RECEIVED @"received"
#define ORDER_STATUS_SUCCESS @"success"
#define ORDER_STATUS_FAIL @"fail"

//颜色配置
//主背景
#define COLOR_MAIN_BG @"EEEEEE"
//高亮背景
#define COLOR_HIGHLIGHTED_BG @"E2383B"
//主边框
#define COLOR_MAIN_BORDER @"D8D8D8"
//主标题背景
#define COLOR_MAIN_TITLE_BG @"F8F8F8"
//主标题
#define COLOR_MAIN_TITLE @"000000"
//首页标题背景
//红色背景
//#define COLOR_INDEX_TITLE_BG @"E2383B"
//白色背景
#define COLOR_INDEX_TITLE_BG @"FFFFFF"
//首页标题文字
//白色文字
//#define COLOR_INDEX_TITLE @"FFFFFF"
//红色文字
#define COLOR_INDEX_TITLE @"E2383B"
//文字颜色
#define COLOR_MAIN_TEXT @"000000"
//文字高亮
#define COLOR_MAIN_TEXT_HIGHLIGHTED @"F15353"
//文字背景
#define COLOR_MAIN_TEXT_BG @"FFFFFF"
//button 文字
#define COLOR_MAIN_BUTTON @"FFFFFF"
//button 背景
#define COLOR_MAIN_BUTTON_BG @"F15353"

//字体配置
//标题字体
#define SIZE_TITLE_TEXT 20
//导航文字字体
#define SIZE_BAR_TEXT 16
//主要字体
#define SIZE_MAIN_TEXT 16
//大按钮文字
#define SIZE_BUTTON_TEXT 16
//中按钮文字
#define SIZE_MIDDLE_BUTTON_TEXT 14
//中号字体
#define SIZE_MIDDLE_TEXT 14
//小号字体
#define SIZE_SMALL_TEXT 12

//按钮配置
//中按钮高度
#define HEIGHT_MIDDLE_BUTTON 35
//大按钮高度
#define HEIGHT_MAIN_BUTTON 45
/********<<<公用配置********/


#endif
