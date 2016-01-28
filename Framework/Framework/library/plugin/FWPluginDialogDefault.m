//
//  FWPluginDialogMBProgressHUD.m
//  Framework
//
//  Created by wuyong on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginDialogDefault.h"
#import "TSMessage.h"

@implementation FWPluginDialogDefault

- (void)showDialogInViewController:(UIViewController *)viewController message:(NSString *)message type:(FWPluginDialogType)type callback:(void (^)())callback
{
    TSMessageNotificationType tsType;
    switch (type) {
        case FWPluginDialogTypeWarning:
            tsType = TSMessageNotificationTypeWarning;
            break;
        case FWPluginDialogTypeError:
            tsType = TSMessageNotificationTypeError;
            break;
        case FWPluginDialogTypeSuccess:
            tsType = TSMessageNotificationTypeSuccess;
            break;
        default:
            tsType = TSMessageNotificationTypeMessage;
            break;
    }
    
    [self showDialogInViewController:viewController message:message type:tsType callback:callback buttonTitle:nil buttonCallback:nil];
}

- (void)showButtonInViewController:(UIViewController *)viewController message:(NSString *)message title:(NSString *)title callback:(void (^)())callback
{
    [self showDialogInViewController:viewController message:message type:TSMessageNotificationTypeMessage callback:nil buttonTitle:title buttonCallback:callback];
}

- (void)hideDialogInViewController:(UIViewController *)viewController
{
    [self hideDialogCallback:nil];
}

- (void)showDialogInViewController:(UIViewController *)viewController message: (NSString *)message type: (TSMessageNotificationType) type callback:(void (^)())callback buttonTitle: (NSString *) buttonTitle buttonCallback: (void (^)())buttonCallback
{
    [self hideDialogInViewController:viewController];
    
    [TSMessage showNotificationInViewController:viewController
                                          title:message
                                       subtitle:nil
                                          image:nil
                                           type:type
                                       duration:(callback || buttonCallback) ? TSMessageNotificationDurationEndless : DIALOG_SHOW_TIME
                                       callback:nil
                                    buttonTitle:buttonTitle
                                 buttonCallback:buttonCallback
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:(callback || buttonCallback) ? NO : YES];
    
    if (callback) {
        [self performSelector:@selector(hideDialogCallback:) withObject:callback afterDelay:DIALOG_SHOW_TIME];
    }
}

- (void) hideDialogCallback:(void (^)())callback
{
    [TSMessage dismissActiveNotificationWithCompletion:callback];
}

@end
