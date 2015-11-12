//
//  应用配置文件，包含此文件即可
//  Config.h
//  LttMerchant
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#ifndef LttMerchant_Config_h
#define LttMerchant_Config_h


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
//用户心跳间隔
#define USER_HEARTBEAT_INTERVAL 10.0

//短信验证码发送间隔
#define USER_SMS_INTERVAL 60

//默认每页数量
#define LTT_PAGESIZE_DEFAULT 10

//客户端类型
#define LTT_CLIENT_TYPE @"MM"

//用户登录类型
#define USER_TYPE_MERCHANT @"merchant"

//通用服务类型
#define LTT_SERVICE_CATEGORYID -1
#define LTT_SERVICE_CATEGORYNAME @"上门服务"

//行业列表
//商品
#define LTT_TRADE_GOODS 1
//服务
#define LTT_TRADE_SERVICE 2

//支付方式列表
#define PAY_WAY_WEIXIN @"weixin"
#define PAY_WAY_ALIPAY @"alipay"
#define PAY_WAY_CASH   @"cash"

//用户TOKEN过期
#define ERROR_TOKEN_EXPIRED @"用户授权已过期，请重新登陆！"

//需求状态
#define CASE_STATUS_NEW @"new"
#define CASE_STATUS_LOCKED @"locked"
#define CASE_STATUS_CONFIRMED @"confirmed"
#define CASE_STATUS_TOPAY @"wait_pay"
#define CASE_STATUS_PAYED @"payed"
#define CASE_STATUS_SUCCESS @"success"
#define CASE_STATUS_MEMBER_CANCEL @"member_cancel"
#define CASE_STATUS_MERCHANT_CANCEL @"merchant_cancel"

//颜色配置
#define COLOR_MAIN_BG [UIColor colorWithHexString:@"EEEEEE"]
#define COLOR_MAIN_BUTTON_BG [UIColor colorWithHexString:@"0199FF"]
#define COLOR_MAIN_BORDER [UIColor colorWithHexString:@"B2B2B2"]
#define COLOR_MAIN_WHITE [UIColor whiteColor]
#define COLOR_MAIN_BLACK [UIColor blackColor]
#define COLOR_MAIN_DARK [UIColor colorWithHexString:@"585858"]
#define COLOR_MAIN_GRAY [UIColor colorWithHexString:@"7D7D7D"]
#define COLOR_MAIN_BLUE [UIColor colorWithHexString:@"0199FF"]
#define COLOR_MAIN_HIGHLIGHT [UIColor colorWithHexString:@"FF6600"]
#define COLOR_MAIN_SELECTED [UIColor colorWithHexString:@"E9F0FA"]
#define CGCOLOR_MAIN_BORDER [UIColor colorWithHexString:@"B2B2B2"].CGColor
#define CGCOLOR_MAIN_WHITE [UIColor whiteColor].CGColor

//尺寸配置
#define FONT_MAIN [UIFont systemFontOfSize:16]
#define FONT_MAIN_BOLD [UIFont boldSystemFontOfSize:16]
#define FONT_MIDDLE [UIFont systemFontOfSize:14]
#define FONT_MIDDLE_BOLD [UIFont boldSystemFontOfSize:14]
#define FONT_SMALL [UIFont systemFontOfSize:12]
#define FONT_SMALL_BOLD [UIFont boldSystemFontOfSize:12]

//按钮配置
//中按钮高度
#define HEIGHT_MIDDLE_BUTTON 35
//大按钮高度
#define HEIGHT_MAIN_BUTTON 45

//消息配置
#define ERROR_MOBILE_REQUIRED @"请填写手机号哦~亲！"
#define ERROR_MOBILE_FORMAT @"手机号不正确哦~亲！"
#define ERROR_PASSWORD_REQUIRED @"请填写密码哦~亲！"
#define ERROR_PASSWORD_LENGTH @"密码长度不正确哦~亲！"
#define ERROR_COMMENT_REQUIRED @"请选择评价星级哦~亲！"
#define ERROR_MOBILECODE_REQUIRED @"请填写验证码哦~亲！"
#define ERROR_TOKEN_EXPIRED @"用户授权已过期，请重新登陆！"
#define ERROR_MOBILE_NOTFOUND @"该手机号不存在哦~亲！"
#define ERROR_MERCHANT_REQUIRED @"请填写单位名称哦~亲！"
#define ERROR_MERCHANTADDRESS_REQUIRED @"请填写单位地址哦~亲！"
#define ERROR_CONTACT_REQUIRED @"请填写负责人哦~亲"
#define ERROR_CONTACTID_REQUIRED @"请填写负责人身份证哦~亲"

#define TIP_LOADING_MESSAGE @"加载中"
#define TIP_LOADING_SUCCESS @"加载完成"
#define TIP_LOADING_FAILURE @"加载失败"

#define TIP_REQUEST_MESSAGE @"请求中"
#define TIP_REQUEST_SUCCESS @"请求成功"
#define TIP_REQUEST_FAILURE @"请求失败"
/********<<<公用配置********/


#endif
