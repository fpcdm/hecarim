//
//  FWPluginLoadingDefault.m
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginLoadingDefault.h"
#import "MBProgressHUD.h"

@implementation FWPluginLoadingDefault
{
    MBProgressHUD *loading;
}

- (void)showLoadingInViewController:(UIViewController *)viewController message:(NSString *)message
{
    [self hideLoadingInViewController:viewController];
    
    loading = [[MBProgressHUD alloc] initWithView:viewController.view];
    [viewController.view addSubview:loading];
    
    loading.labelText = message;
    
    //区分模式
    switch (self.mode) {
        case FWPluginLoadingModeText:
        {
            loading.mode = MBProgressHUDModeText;
            loading.margin = 5.0f;
            loading.cornerRadius = 3.0f;
        }
            break;
        default:
            break;
    }
    
    [loading show:YES];
}

- (void)finishLoadingInViewController:(UIViewController *)viewController message:(NSString *)message callback:(void (^)())callback
{
    loading.labelText = message;
    
    //区分模式
    switch (self.mode) {
        case FWPluginLoadingModeText:
            break;
        default:
        {
            loading.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Framework.bundle/LoadingSuccess"]];
            loading.mode = MBProgressHUDModeCustomView;
        }
            break;
    }
    
    [loading show:YES];
    
    if (callback) {
        [self performSelector:@selector(finishLoadingCallback:) withObject:callback afterDelay:FRAMEWORK_TIMEINTERVAL_LOADING];
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
