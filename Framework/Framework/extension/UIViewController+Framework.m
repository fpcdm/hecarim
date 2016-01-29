//
//  UIViewController+Framework.m
//  Framework
//
//  Created by wuyong on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UIViewController+Framework.h"
#import "FWPluginManager.h"

@implementation UIViewController (Framework)

- (id<FWPluginDialog>)dialogPlugin
{
    id plugin = [[FWPluginManager sharedInstance] getPlugin:FWPluginDialogName];
    return (id<FWPluginDialog>) plugin;
}

- (id<FWPluginLoading>)loadingPlugin
{
    id plugin = [[FWPluginManager sharedInstance] getPlugin:FWPluginLoadingName];
    return (id<FWPluginLoading>) plugin;
}

- (void)showLoading:(NSString *)message
{
    [[self loadingPlugin] showLoadingInViewController:self message:message];
}

- (void)finishLoading:(NSString *)message callback:(void (^)())callback
{
    [[self loadingPlugin] finishLoadingInViewController:self message:message callback:callback];
}

- (void)hideLoading
{
    [[self loadingPlugin] hideLoadingInViewController:self];
}

- (void)showDialog:(FWPluginDialogType)type message:(NSString *)message callback:(void (^)())callback
{
    [[self loadingPlugin] hideLoadingInViewController:self];
    [[self dialogPlugin] showDialogInViewController:self type:type message:message callback:callback];
}

- (void)showMessage:(NSString *)message callback:(void (^)())callback
{
    [self showDialog:FWPluginDialogTypeMessage message:message callback:callback];
}

- (void)showWarning:(NSString *)message callback:(void (^)())callback
{
    [self showDialog:FWPluginDialogTypeWarning message:message callback:callback];
}

- (void)showError:(NSString *)message callback:(void (^)())callback
{
    [self showDialog:FWPluginDialogTypeError message:message callback:callback];
}

- (void)showSuccess:(NSString *)message callback:(void (^)())callback
{
    [self showDialog:FWPluginDialogTypeSuccess message:message callback:callback];
}

- (void)showButton:(NSString *)message title:(NSString *)title callback:(void (^)())callback
{
    [[self loadingPlugin] hideLoadingInViewController:self];
    [[self dialogPlugin] showButtonInViewController:self message:message title:title callback:callback];
}

- (void)hideDialog
{
    [[self dialogPlugin] hideDialogInViewController:self];
}

@end
