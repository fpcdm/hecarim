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
#import "FrameworkConfig.h"

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

- (NSString *)trim;

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
