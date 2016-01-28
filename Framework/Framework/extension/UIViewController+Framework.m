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

- (void)showDialog:(NSString *)message type:(FWPluginDialogType)type callback:(void (^)())callback
{
    [[self loadingPlugin] hideLoadingInViewController:self];
    [[self dialogPlugin] showDialogInViewController:self message:message type:type callback:callback];
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
