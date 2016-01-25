//
//  UIViewController+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWPluginDialog.h"

@interface UIViewController (Framework)

//显示加载条
- (void)showLoading:(NSString *)message;

//显示加载完成
- (void)finishLoading:(NSString *)message callback:(void(^)())callback;

//隐藏加载条
- (void)hideLoading;

//显示弹出框
- (void)showDialog:(NSString *)message type:(FWPluginDialogType)type callback:(void(^)())callback;

//显示按钮弹出框
- (void)showButton:(NSString *)message title:(NSString *)title callback:(void(^)())callback;

//隐藏弹出框
- (void)hideDialog;

@end
