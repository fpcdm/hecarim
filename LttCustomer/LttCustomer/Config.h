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
/********>>>加载环境配置********/


#pragma mark - 公用配置
/********公用配置>>>********/
//用户登录类型
#define USER_TYPE_MEMBER @"member"

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
#define COLOR_MAIN_BG @"EEEEEE"
#define COLOR_MAIN_BORDER @"D8D8D8"
#define COLOR_MAIN_TITLE_BG @"FF4400"
#define COLOR_MAIN_TITLE @"FFFFFF"
#define COLOR_MAIN_TEXT @"000000"
#define COLOR_MAIN_TEXT_BG @"FFFFFF"
#define COLOR_MAIN_BUTTON @"FFFFFF"
#define COLOR_MAIN_BUTTON_BG @"FF0000"

//字体配置
#define SIZE_TITLE_TEXT 18
#define SIZE_BAR_TEXT 16
#define SIZE_MAIN_TEXT 16
#define SIZE_BUTTON_TEXT 16

//按钮配置
#define HEIGHT_MAIN_BUTTON 30
#define HEIGHT_BIG_BUTTON 45
/********<<<公用配置********/


#endif
