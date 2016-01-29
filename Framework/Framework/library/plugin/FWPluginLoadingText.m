//
//  FWPluginLoadingText.m
//  Framework
//
//  Created by wuyong on 16/1/29.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginLoadingText.h"
#import "MBProgressHUD.h"

@implementation FWPluginLoadingText
{
    MBProgressHUD *loading;
}

- (void)showLoadingInViewController:(UIViewController *)viewController message:(NSString *)message
{
    [self hideLoadingInViewController:viewController];
    
    loading = [[MBProgressHUD alloc] initWithView:viewController.view];
    [viewController.view addSubview:loading];
    
    loading.mode = MBProgressHUDModeText;
    loading.labelText = message;
    loading.margin = 5.0f;
    loading.cornerRadius = 3.0f;
    
    [loading show:YES];
}

- (void)finishLoadingInViewController:(UIViewController *)viewController message:(NSString *)message callback:(void (^)())callback
{
    loading.labelText = message;
    
    [loading show:YES];
    
    if (callback) {
        [self performSelector:@selector(finishLoadingCallback:) withObject:callback afterDelay:LOADING_SUCCESS_TIME];
    }
}

- (void)finishLoadingCallback:(void(^)())callback
{
    [self hideLoadingInViewController:nil];
    callback();
}

- (void)hideLoadingInViewController:(UIViewController *)viewController
{
    if (loading) {
        [loading hide:NO];
        loading = nil;
    }
}

@end
