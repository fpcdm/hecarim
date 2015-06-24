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
    [TSMessage showNotificationInViewController:self
                                          title:message
                                       subtitle:nil
                                          image:nil
                                           type:TSMessageNotificationTypeError
                                       duration:DIALOG_SHOW_TIME
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}

- (void) showSuccess: (NSString *) message
{
    [TSMessage showNotificationInViewController:self
                                          title:message
                                       subtitle:nil
                                          image:nil
                                           type:TSMessageNotificationTypeSuccess
                                       duration:DIALOG_SHOW_TIME
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}

- (void) showLoading: (NSString *) message
{
    loading = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:loading];
    
    loading.labelText = message;
    
    [loading show:YES];
}

- (void) loadingSuccess: (NSString *) message
{
    loading.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    loading.mode = MBProgressHUDModeCustomView;
    
    loading.labelText = message;
    
    [loading show:YES];
}

- (void) hideLoading
{
    [loading hide:NO];
    loading = nil;
}

- (void) showNotification:(NSString *)message
{
    [TSMessage showNotificationInViewController:self
                                          title:message
                                       subtitle:nil
                                          image:nil
                                           type:TSMessageNotificationTypeMessage
                                       duration:DIALOG_SHOW_TIME
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}

@end
