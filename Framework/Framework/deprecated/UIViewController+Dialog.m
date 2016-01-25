//
//  UIViewController+Dialog.m
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "UIViewController+Dialog.h"

@implementation UIViewController (Dialog)

- (void) showError: (NSString *) message
{
    [self showDialog:message type:FWPluginDialogTypeError callback:nil];
}

- (void) showWarning:(NSString *) message
{
    [self showDialog:message type:FWPluginDialogTypeWarning callback:nil];
}

- (void) showMessage:(NSString *) message
{
    [self showDialog:message type:FWPluginDialogTypeMessage callback:nil];
}

- (void) showSuccess: (NSString *) message
{
    [self showDialog:message type:FWPluginDialogTypeSuccess callback:nil];
}

- (void) showSuccess:(NSString *)message callback:(void (^)())callback
{
    [self showDialog:message type:FWPluginDialogTypeSuccess callback:callback];
}

- (void) showNotification:(NSString *)message callback:(void (^)())callback
{
    [self showButton:message title:@" 查 看 " callback:callback];
}

- (void) loadingSuccess: (NSString *) message
{
    [self finishLoading:message callback:nil];
}

- (void) loadingSuccess:(NSString *)message callback:(void (^)())callback
{
    [self finishLoading:message callback:callback];
}

@end
