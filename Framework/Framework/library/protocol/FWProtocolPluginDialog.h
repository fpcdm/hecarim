//
//  FWProtocolPluginDialog.h
//  Framework
//
//  Created by wuyong on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWProtocolPlugin.h"

//定义插件池默认保存名称
#define FWProtocolPluginDialogName @"FWProtocolPluginDialog"

//弹出框类型枚举
typedef NS_ENUM(NSInteger, FWPluginDialogType) {
    FWPluginDialogTypeMessage = 0,
    FWPluginDialogTypeWarning,
    FWPluginDialogTypeError,
    FWPluginDialogTypeSuccess
};

@protocol FWProtocolPluginDialog <FWProtocolPlugin>

//显示加载条
- (void)showLoadingInViewController:(UIViewController *)viewController message:(NSString *)message;

//显示加载完成
- (void)finishLoadingInViewController:(UIViewController *)viewController message:(NSString *)message callback:(void(^)())callback;

//隐藏加载条
- (void)hideLoadingInViewController:(UIViewController *)viewController;

//显示弹出框
- (void)showDialogInViewController:(UIViewController *)viewController message:(NSString *)message type:(FWPluginDialogType)type callback:(void(^)())callback;

//显示按钮弹出框
- (void)showButtonInViewController:(UIViewController *)viewController message:(NSString *)message title:(NSString *)title callback:(void(^)())callback;

//隐藏弹出框
- (void)hideDialogInViewController:(UIViewController *)viewController;

@end
