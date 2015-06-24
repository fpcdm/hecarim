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
/********<<<公用配置********/


#endif
