//
//  FWPluginDialog.h
//  Framework
//
//  Created by 吴勇 on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义插件池默认保存名称
#define FWPluginDialogName @"FWPluginDialog"

TODO("去掉枚举，用static_integer")

//弹出框类型枚举
typedef NS_ENUM(NSInteger, FWPluginDialogType) {
    FWPluginDialogTypeMessage = 0,
    FWPluginDialogTypeWarning,
    FWPluginDialogTypeError,
    FWPluginDialogTypeSuccess
};

//弹出框协议
@protocol FWPluginDialog <NSObject>

//显示弹出框
- (void)showDialogInViewController:(UIViewController *)viewController type:(FWPluginDialogType)type message:(NSString *)message callback:(void(^)())callback;

//显示按钮弹出框
- (void)showButtonInViewController:(UIViewController *)viewController message:(NSString *)message title:(NSString *)title callback:(void(^)())callback;

//隐藏弹出框
- (void)hideDialogInViewController:(UIViewController *)viewController;

@end
