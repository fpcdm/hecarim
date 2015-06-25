//
//  UIViewController+Ltt.m
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "UIViewController+Ltt.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "FrameworkConfig.h"
#import "TSMessage.h"

//实现扩展UIViewController分类方法
static MBProgressHUD *loading = nil;

@implementation UIViewController (Ltt)

- (void) showError: (NSString *) message
{
    [self showDialog:message type:TSMessageNotificationTypeError callback:nil];
}

- (void) showWarning:(NSString *) message
{
    [self showDialog:message type:TSMessageNotificationTypeWarning callback:nil];
}

- (void) showMessage:(NSString *) message
{
    [self showDialog:message type:TSMessageNotificationTypeMessage callback:nil];
}

- (void) showSuccess: (NSString *) message
{
    [self showDialog:message type:TSMessageNotificationTypeSuccess callback:nil];
}

- (void) showSuccess:(NSString *)message callback:(void (^)())callback
{
    [self showDialog:message type:TSMessageNotificationTypeSuccess callback:callback];
}

- (void) showDialog: (NSString *)message type: (TSMessageNotificationType) type callback:(void (^)())callback
{
    [self hideLoading];
    
    [TSMessage showNotificationInViewController:self
                                          title:message
                                       subtitle:nil
                                          image:nil
                                           type:type
                                       duration:callback ? TSMessageNotificationDurationEndless : DIALOG_SHOW_TIME
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:callback ? NO : YES];
    
    if (callback) {
        [self performSelector:@selector(showDialogCallback:) withObject:callback afterDelay:DIALOG_SHOW_TIME];
    }
}

- (void) showDialogCallback:(void (^)())callback
{
    [TSMessage dismissActiveNotificationWithCompletion:callback];
}

- (void) showLoading: (NSString *) message
{
    [self hideLoading];
    
    loading = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:loading];
    
    loading.labelText = message;
    
    [loading show:YES];
}

- (void) loadingSuccess: (NSString *) message
{
    [self loadingSuccess:message callback:nil];
}

- (void) loadingSuccess:(NSString *)message callback:(void (^)())callback
{
    loading.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    loading.mode = MBProgressHUDModeCustomView;
    
    loading.labelText = message;
    
    [loading show:YES];
    
    if (callback) {
        [self performSelector:@selector(loadingSuccessCallback:) withObject:callback afterDelay:LOADING_SUCCESS_TIME];
    }
}

- (void)loadingSuccessCallback:(void (^)())callback
{
    [self hideLoading];
    callback();
}

- (void) hideLoading
{
    if (loading) {
        [loading hide:NO];
        loading = nil;
    }
}

@end
