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
//定时器刷新时间
#define SCHEDULED_TIME_INTERVAL 5

//本地通知KEY
#define SCHEDULED_USERINFO_KEY @"refreshIntention"

//用户登录类型
#define USER_TYPE_MERCHANT @"merchant"

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
/********<<<公用配置********/


#endif
