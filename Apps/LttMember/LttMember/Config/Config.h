//
//  应用配置文件，包含此文件即可
//  Config.h
//  LttMember
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#ifndef LttMember_Config_h
#define LttMember_Config_h


#pragma mark - 框架配置
/********框架配置>>>********/
#import "FrameworkConfig.h"
/********<<<框架配置********/


#pragma mark - 环境配置
/********加载环境配置>>>********/
//环境配置
#ifdef APP_DEBUG
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
//AppStoreId配置
#define LTT_APPSTORE_ID @"1052030566"

//客户端类型
#define LTT_CLIENT_TYPE @"GM"

//用户登录类型
#define USER_TYPE_MEMBER @"member"

//客服电话
#define LTT_CUSTOMER_SERVICE @"400-088-2552"

//用户心跳时间
#define USER_HEARTBEAT_INTERVAL 60.0

//刷新位置间隔
#define USER_LOCATION_INTERVAL 60.0

//短信验证码发送间隔
#define USER_SMS_INTERVAL 60

//默认每页数量
#define LTT_PAGESIZE_DEFAULT 10

//需求类型缓存KEY
#define LTT_STORAGE_KEY_CASE_TYPES @"case_types"
#define LTT_STORAGE_KEY_CITY_NAME @"city_name"

/*** 友盟分享配置 ***/
//友盟分享AppKey
#define UMENG_SHARE_APPKEY @"565fac3567e58efb80001b98"
//友盟分享链接，根据平台自动跳转
#define UMENG_SHARE_URL @"http://www.lttok.com/mobile"
//友盟分享标题
#define UMENG_SHARE_TITLE @"我在使用两条腿手机客户端"
//友盟分享内容
#define UMENG_SHARE_TEXT @"中国同城送货上门服务第一品牌。\n中国首家专注提供同城上门服务的服务品牌。\nhttp://www.lttok.com/mobile"
//友盟微信APPID，还需要替换URL schemes中的APPID
#define UMENG_WEIXIN_APPID @"wx00a2b7c29ef17dbc"
//友盟微信APPKEY
#define UMENG_WEIXIN_APPKEY @"6577e11279f937b04293038f3b5a14ba"
//友盟新浪微博APPKEY，还需要替换URL schemes中的APPKEY
#define UMENG_SINA_APPKEY @"3881161679"
//友盟新浪回调地址
#define UMENG_SINA_REDIRECTURL @"http://sns.whalecloud.com/sina2/callback"
//友盟QQ和空间APPID，还需要替换URL schemes中的"tencent"+appId和"QQ"+appId转换成十六进制（不足8位前面补0）
#define UMENG_QQ_APPID @"1104927007"
//友盟QQ和空间APPKEY
#define UMENG_QQ_APPKEY @"NdITOjuOyAwG3c16"
/*** 友盟分享配置 ***/

//需求类型
//汽车金融
#define LTT_TYPE_AUTOFINANCE 4

//支付URL Scheme
#define URL_SCHEME_WEIXIN_QRCODE @"weixin://dl/scan"
#define URL_SCHEME_ALIPAY_QRCODE @"alipayqr://platformapi/startapp?saId=10000007"

//支付宝回调URL Scheme
#define URL_SCHEME_APIPAY_CALLBACK @"alisdkcomlttoklttmember"

//协议URL
#define URL_REGISTER_PROTOCOL @"http://www.lttok.com/protocol"

//第三方登陆列表
#define THIRD_LOGIN_TYPE_WECHAT 1
#define THIRD_LOGIN_TYPE_QQ 2
#define THIRD_LOGIN_TYPE_SINA 3

//支付类型列表
#define PAY_TYPE_RECHARGE 1
#define PAY_TYPE_PLATFORM 2
#define PAY_TYPE_MERCHANT 3

//支付方式列表
#define PAY_WAY_BALANCE @"balance"
#define PAY_WAY_WEIXIN @"weixin"
#define PAY_WAY_ALIPAY @"alipay"
#define PAY_WAY_CASH   @"cash"

//支付结果枚举
typedef enum {
    //支付成功
    LttPayStatusSuccess = 1,
    //支付取消
    LttPayStatusCanceled,
    //支付失败
    LttPayStatusFailed
} LttPayStatus;

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
#define COLOR_MAIN_BUTTON_BG [UIColor colorWithHexString:@"F38600"]
#define COLOR_MAIN_HIGHLIGHT [UIColor colorWithHexString:@"F38600"]
#define COLOR_MAIN_BORDER [UIColor colorWithHexString:@"B2B2B2"]
#define COLOR_MAIN_WHITE [UIColor whiteColor]
#define COLOR_MAIN_BLACK [UIColor blackColor]
#define COLOR_MAIN_CLEAR [UIColor clearColor]
#define COLOR_MAIN_DARK [UIColor colorWithHexString:@"585858"]
#define COLOR_MAIN_GRAY [UIColor colorWithHexString:@"7D7D7D"]
#define CGCOLOR_MAIN_BORDER [UIColor colorWithHexString:@"B2B2B2"].CGColor
#define CGCOLOR_MAIN_WHITE [UIColor whiteColor].CGColor
#define CGCOLOR_MAIN_HIGHLIGHT [UIColor colorWithHexString:@"F38600"].CGColor

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