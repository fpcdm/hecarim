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

- (void)showLoading:(NSString *)message
{
    [[self dialogPlugin] showLoadingInViewController:self message:message];
}

- (void)finishLoading:(NSString *)message callback:(void (^)())callback
{
    [[self dialogPlugin] finishLoadingInViewController:self message:message callback:callback];
}

- (void)hideLoading
{
    [[self dialogPlugin] hideLoadingInViewController:self];
}

- (void)showDialog:(NSString *)message type:(FWPluginDialogType)type callback:(void (^)())callback
{
    [[self dialogPlugin] showDialogInViewController:self message:message type:type callback:callback];
}

- (void)showButton:(NSString *)message title:(NSString *)title callback:(void (^)())callback
{
    [[self dialogPlugin] showButtonInViewController:self message:message title:title callback:callback];
}

- (void)hideDialog
{
    [[self dialogPlugin] hideDialogInViewController:self];
}

@end
