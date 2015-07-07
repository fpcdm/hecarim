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
//客户端类型
#define LTT_CLIENT_TYPE @"MC"

//用户登录类型
#define USER_TYPE_MEMBER @"member"

//客服电话
#define LTT_CUSTOMER_SERVICE @"400-820-5555"

//用户心跳时间
#define USER_HEARTBEAT_INTERVAL 10.0

//需求类型
//买手机
#define LTT_TYPE_MOBILE 1
//手机上门
#define LTT_TYPE_MOBILEDOOR 2
//电脑上门
#define LTT_TYPE_COMPUTERDOOR 3

//需求状态
#define CASE_STATUS_NEW @"new"
#define CASE_STATUS_LOCKED @"locked"
#define CASE_STATUS_CONFIRMED @"confirmed"
#define CASE_STATUS_TOPAY @"wait_pay"
#define CASE_STATUS_PAYED @"payed"
#define CASE_STATUS_SUCCESS @"success"
#define CASE_STATUS_MEMBER_CANCEL @"member_cancel"
#define CASE_STATUS_MERCHANT_CANCEL @"merchant_cancel"

//颜色配置：@todo优化
//主背景
#define COLOR_MAIN_BG @"EEEEEE"
//高亮背景
#define COLOR_HIGHLIGHTED_BG @"E2383B"
//主边框
#define COLOR_MAIN_BORDER @"B2B2B2"
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
//文字深色
#define COLOR_DARK_TEXT @"585858"
//文字灰色
#define COLOR_GRAY_TEXT @"7D7D7D"
//文字高亮
//#define COLOR_MAIN_TEXT_HIGHLIGHTED @"F15353"
#define COLOR_MAIN_TEXT_HIGHLIGHTED @"E2383B"
//文字背景
#define COLOR_MAIN_TEXT_BG @"FFFFFF"
//button 文字
#define COLOR_MAIN_BUTTON @"FFFFFF"
//button 背景
//#define COLOR_MAIN_BUTTON_BG @"F15353"
#define COLOR_MAIN_BUTTON_BG @"E2383B"

//字体配置:@todo 优化
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
#define HEIGHT_MIDDLE_BUTTON 45
//大按钮高度
#define HEIGHT_MAIN_BUTTON 45

//消息配置
#define ERROR_MOBILE_REQUIRED @"请填写手机号哦~亲！"
#define ERROR_MOBILE_FORMAT @"手机号不正确哦~亲！"
#define ERROR_PASSWORD_REQUIRED @"请填写密码哦~亲！"
#define ERROR_COMMENT_REQUIRED @"请选择评价星级哦~亲！"
#define ERROR_TOKEN_EXPIRED @"用户授权已过期，请重新登陆！"

#define TIP_LOADING_MESSAGE @"加载中"
#define TIP_LOADING_SUCCESS @"加载完成"
#define TIP_LOADING_FAILURE @"加载失败"

#define TIP_REQUEST_MESSAGE @"请求中"
#define TIP_REQUEST_SUCCESS @"请求成功"
#define TIP_REQUEST_FAILURE @"请求失败"
/********<<<公用配置********/


#endif
