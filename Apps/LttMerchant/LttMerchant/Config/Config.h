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
#import "LttFramework.h"
/********<<<框架配置********/


#pragma mark - 环境配置
/********加载环境配置>>>********/
//环境配置
#ifdef APP_DEBUG
#import "Config_debug.h"
#else
#import "Config_product.h"
#endif
/********>>>加载环境配置********/


#pragma mark - 公用配置
/********公用配置>>>********/
//AppStoreId配置
#define LTT_APPSTORE_ID @"1018116988"

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

/*** 友盟分享配置 ***/
//友盟分享AppKey
#define UMENG_SHARE_APPKEY @"56c66e48e0f55a8994000518"
//友盟分享链接，根据平台自动跳转
#define UMENG_SHARE_URL @"http://www.lttok.com/mobile"
//友盟分享标题
#define UMENG_SHARE_TITLE @"我在使用两条腿生意宝"
//友盟分享内容
#define UMENG_SHARE_TEXT @"中国同城送货上门服务第一品牌。\n中国首家专注提供同城上门服务的服务品牌。\nhttp://www.lttok.com/mobile"
//友盟微信APPID，还需要替换URL schemes中的APPID
#define UMENG_WEIXIN_APPID @"wx13027d38d8233000"
//友盟微信APPKEY
#define UMENG_WEIXIN_APPKEY @"f3d24d467f1137f190eb2fabf2d5040d"
//友盟新浪微博APPKEY，还需要替换URL schemes中的APPKEY
#define UMENG_SINA_APPKEY @"1411372117"
//友盟新浪回调地址
#define UMENG_SINA_REDIRECTURL @"http://sns.whalecloud.com/sina2/callback"
//友盟QQ和空间APPID，还需要替换URL schemes中的"tencent"+appId和"QQ"+appId转换成十六进制（不足8位前面补0）
#define UMENG_QQ_APPID @"1105115627"
//友盟QQ和空间APPKEY
#define UMENG_QQ_APPKEY @"wtMZqqD5SN4CaZy9"
/*** 友盟分享配置 ***/

//通用服务类型
#define LTT_SERVICE_CATEGORYID -1
#define LTT_SERVICE_CATEGORYNAME @"上门服务"

//行业列表
//商品
#define LTT_TRADE_GOODS 1
//服务
#define LTT_TRADE_SERVICE 2

//协议URL
#define URL_REGISTER_PROTOCOL @"http://www.lttok.com/protocol/merchant"

//支付方式列表
#define PAY_WAY_WEIXIN @"weixin"
#define PAY_WAY_ALIPAY @"alipay"
#define PAY_WAY_CASH   @"cash"

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

/********<<<公用配置********/


#endif
