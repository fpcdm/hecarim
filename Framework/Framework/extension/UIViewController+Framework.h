//
//  UIViewController+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWPluginDialog.h"
#import "FWPluginLoading.h"

@protocol UIViewControllerFrameworkDelegate <NSObject>

@optional
//重写返回事件
- (BOOL)shouldNavigationBarPopItem;

@end

@interface UIViewController (Framework) <UIViewControllerFrameworkDelegate>

//屏幕边界
- (CGRect)screenBounds;

//有效边界(自动扣除状态栏，导航栏，TabBar)
- (CGRect)availBounds;

//显示加载条
- (void)showLoading:(NSString *)message;

//显示加载完成
- (void)finishLoading:(NSString *)message callback:(void(^)())callback;

//隐藏加载条
- (void)hideLoading;

//显示弹出框
- (void)showDialog:(FWPluginDialogType)type message:(NSString *)message callback:(void(^)())callback;

//显示消息弹出框
- (void)showMessage:(NSString *)message callback:(void(^)())callback;

//显示警告弹出框
- (void)showWarning:(NSString *)message callback:(void(^)())callback;

//显示错误弹出框
- (void)showError:(NSString *)message callback:(void(^)())callback;

//显示成功弹出框
- (void)showSuccess:(NSString *)message callback:(void(^)())callback;

//显示按钮弹出框
- (void)showButton:(NSString *)message title:(NSString *)title callback:(void(^)())callback;

//隐藏弹出框
- (void)hideDialog;

//切换view视图,类似push效果
- (void)pushView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion;

//切换view视图,类似pop效果
- (void)popView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion;

@end
