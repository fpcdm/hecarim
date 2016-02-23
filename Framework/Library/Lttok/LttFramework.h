//
//  LttFramework.h
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Framework.h"

/***************************/
#ifndef LttFramework_FrameworkConfig_h
#define LttFramework_FrameworkConfig_h


#pragma mark - 环境配置
#ifdef APP_DEBUG
/********开发环境>>>********/
//接口服务器根地址
#define APP_REST_SERVER @"http://maokai.web.dm/"
//#define APP_REST_SERVER @"http://mfz0hbeutmqhsxr.lttok.com/"

//接口服务器是否为RAP
#define APP_REST_RAP NO
/********>>>开发环境********/
#else
/********正式环境>>>********/
//接口服务器根地址
#define APP_REST_SERVER @"http://maokai.lttok.com/"

//接口服务器是否为RAP
#define APP_REST_RAP NO
/********>>>正式环境********/
#endif


#pragma mark - 公用配置
/********公用配置>>>********/
//定义弹出框停留时间
#define DIALOG_SHOW_TIME 2.0
//定义成功框显示时间
#define LOADING_SUCCESS_TIME 0.5
//定义WatchUrl默认刷新间隔
#define DEBUG_WATCHURL_INTERVAL 5.0
//定义HTTP请求超时时间
#define INTERVAL_HTTP_TIMEOUT 10

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
#define SCREEN_STATUSBAR_HEIGHT STATUSBAR_HEIGHT
#define SCREEN_NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define SCREEN_AVAILABLE_HEIGHT (SCREEN_HEIGHT - SCREEN_STATUSBAR_HEIGHT - SCREEN_NAVIGATIONBAR_HEIGHT)

// 判断是否大于等于ios9
#define IS_IOS9_PLUS (IOS_VERSION >= 9.0 ? YES : NO)
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
#define IS_RETINA ([[UIScreen mainScreen] scale] > 1 ? YES : NO)

//判断是否是模拟器
#if TARGET_IPHONE_SIMULATOR
#define IS_IPHONE_SIMULATOR YES
#define IS_IPHONE_OS NO
#else
#define IS_IPHONE_SIMULATOR NO
#define IS_IPHONE_OS YES
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

/***************************/
typedef FWLocale LocaleUtil;

/***************************/
@interface UIColor (Hex)

//兼容方法
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

/****************************/
@interface NSString (Trim)

+ (NSString *)trim:(NSString *)str;

@end

/****************************/
#import "UserEntity.h"

@interface StorageUtil : NSObject

+ (StorageUtil *) sharedStorage;

- (NSUserDefaults *) storage;

//整理字典数据，去掉NSNull和nil，使其可以保存至NSUserDefaults
- (NSDictionary *) prepareDictionary: (NSDictionary *) dictionary;

- (void) setUser: (UserEntity *) user;

- (UserEntity *) getUser;

- (void) setRemoteNotification: (NSDictionary *)notification;

- (NSDictionary *) getRemoteNotification;

- (void) setDeviceId: (NSString *) deviceId;

- (NSString *) getDeviceId;

- (void) setData:(NSString *)key object:(id)object;

- (id) getData:(NSString *)key;

@end

/******************************/
//兼容之前代码
@interface UIViewController (Dialog)

- (void) showError: (NSString *) message;
- (void) showMessage: (NSString *) message;
- (void) showWarning: (NSString *) message;
- (void) showSuccess: (NSString *) message;
- (void) showNotification: (NSString *) message callback:(void(^)()) callback;

- (void) loadingSuccess: (NSString *) message;
- (void) loadingSuccess: (NSString *) message callback:(void(^)()) callback;

@end;

/********************************/
@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end

/*******************************/
@interface ValidateUtil : NSObject

+ (BOOL) isRequired: (NSString *) value;
+ (BOOL) isLength: (NSString *) value length: (NSInteger) length;
+ (BOOL) isMobile: (NSString *) value;
+ (BOOL) isLengthBetween: (NSString *) value from: (NSInteger) from to: (NSInteger) to;
//是否是正整数
+ (BOOL) isPositiveInteger: (NSString *) value;
//是否是正数
+ (BOOL) isPositiveNumber: (NSString *) value;

@end

/*******************************/
typedef FWHelperTimer TimerUtil;

@interface FWHelperTimer (Interval)

//计算离当前时间的间隔
+ (NSTimeInterval) timeInterval: (NSDate *) time;

+ (void) test;

@end

/******************************/
#import <CoreLocation/CoreLocation.h>

@protocol LocationUtilDelegate <NSObject>

@required
- (void) updateLocationSuccess: (CLLocationCoordinate2D) position;
- (void) updateLocationError: (NSError *) error;

@end

@interface LocationUtil : NSObject

//计算两点距离，单位:米
+ (double) getDistance:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to;

+ (LocationUtil *) sharedInstance;

- (CLLocationManager *) locationManager;

- (CLLocationCoordinate2D) position;

//开始更新位置
- (void) startUpdate;

//停止更新位置
- (void) stopUpdate;

//刷新位置
- (void) restartUpdate;

@property (retain, nonatomic) id<LocationUtilDelegate> delegate;

@end

/*********************************/
@interface NotificationUtil : NSObject

+ (void) registerLocalNotification: (NSString *) userInfoKey alertBody: (NSString *) alertBody time: (NSInteger) time;

+ (void) receiveLocalNotification: (UILocalNotification *) notification;

+ (void) cancelLocalNotifications;

+ (void) receiveRemoteNotification: (NSDictionary *)userInfo;

+ (void) cancelRemoteNotifications;

@end

/*********************************/
//
//  联动选择器，支持一级，两级，三级联动
//
//  依赖：ActionSheetPicker
//
//  示例代码：
//  PickerUtil *pickerUtil = [[PickerUitl alloc] init];
//  pickerUitl.grade = 1;
//  pickerUtil.title = nil;
//  pickerUtil.origin = self.view;
//  pickerUtil.firstLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){ completionHandler(rows); };
//  pickerUtil.resultBlock = ^(NSArray *selectedRows){ PickerUtilRow *row = [selectedRows objectAtIndex:0]; };
//  [pickerUtil show];
//
//  Created by Wuyong on 15-8-4.
//
//

#import "ActionSheetPicker.h"

//加载数据完成句柄
typedef void (^PickerUtilCompletionHandler)(NSArray *rows);

//加载数据代码块
typedef void (^PickerUtilLoadBlock)(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler);

//选择完成代码块
typedef void (^PickerUtilResultBlock)(NSArray *selectedRows);

//选择器行数据
@interface PickerUtilRow : NSObject

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) id value;

- (instancetype) initWithName: (NSString *) name value: (id) value;
+ (instancetype) rowWithName: (NSString *) name value: (id) value;

@end

//选择器接口
@interface PickerUtil : NSObject<ActionSheetCustomPickerDelegate>

//选择器级别
@property (assign, nonatomic) NSUInteger grade;

//选择器标题
@property (retain, nonatomic) NSString *title;

//来源对象（UIBarButtonItem或UIView）
@property (retain, nonatomic) id origin;

//加载数据代码块
@property (copy) PickerUtilLoadBlock firstLoadBlock;
@property (copy) PickerUtilLoadBlock secondLoadBlock;
@property (copy) PickerUtilLoadBlock thirdLoadBlock;

//全部选择完成代码块，部分选择不会回调
@property (copy) PickerUtilResultBlock resultBlock;

//初始化
- (instancetype) initWithTitle: (NSString *) title grade: (NSUInteger) grade origin: (id) origin;

//显示选择器
- (void) show;

@end

/********************************************/
#import "RestKit.h"
#import "ErrorEntity.h"
#import "FileEntity.h"

//全局错误代码块：可统一处理错误事件，如未登录等
//返回YES代表继续执行自定义错误事件，NO则中断
typedef BOOL (^RestKitGlobalErrorBlock)(ErrorEntity *error);

//RestKit成功回调代码块
typedef void (^RestKitSuccessBlock)(NSArray *result);

//RestKit失败回调代码块
typedef void (^RestKitErrorBlock)(ErrorEntity *error);

@interface RestKitUtil : NSObject

@property (copy) RestKitGlobalErrorBlock globalErrorBlock;

+ (RestKitUtil *) sharedClient;

- (void) setBaseUrl: (NSURL *) baseUrl;

- (void) setClientType: (NSString *) clientType;

- (void) setCityCode: (NSString *) cityCode;

- (NSString *) formatPath: (NSString *) path  object: (id) object;

- (RKRequestDescriptor *) addRequestDescriptor: (Class) objectClass mappingParam: (id) param;

- (void) removeRequestDescriptor: (RKRequestDescriptor *) requestDescriptor;

- (RKResponseDescriptor *) addResponseDescriptor: (Class) objectClass mappingParam: (id) param;

- (RKResponseDescriptor *) addResponseDescriptor: (Class) objectClass mappingParam: (id) param keyPath: (NSString *) keyPath;

- (void) removeResponseDescriptor: (RKResponseDescriptor *) responseDescriptor;

- (void) putObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure;

- (void) postObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure;

- (void) deleteObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure;

- (void) getObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure;

- (void) postFile: (FileEntity *) file path: (NSString *) path param: (NSDictionary *) param success: (RestKitSuccessBlock) success failure: (RestKitErrorBlock) failure;

@end
