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
#import "CRToast.h"
#import "UIView+Toast.h"
#import "FrameworkConfig.h"

//实现扩展UIViewController分类方法
static MBProgressHUD *loading = nil;

@implementation UIViewController (Ltt)

- (void) showError: (NSString *) message
{
    if (DIALOG_TYPE_TOAST) {
        UIView *toastView = [self toastView:message type:2];
        [self.view showToast:toastView duration:DIALOG_SHOW_TIME position:CSToastPositionCenter];
    } else {
        NSDictionary *options = @{
                                  kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                  kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypePush),
                                  kCRToastUnderStatusBarKey : @(NO),
                                  kCRToastTextKey : message,
                                  kCRToastFontKey : [UIFont systemFontOfSize:15],
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                                  kCRToastTimeIntervalKey : @(DIALOG_SHOW_TIME),
                                  kCRToastBackgroundColorKey : [UIColor colorWithHexString:@"f26e64"],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom),
                                  kCRToastImageKey : [UIImage imageNamed:@"alert.png"],
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:nil];
    }
}

- (void) doCallback: (void (^)()) callback
{
    callback();
}

- (void) showSuccess: (NSString *) message callback: (void (^)()) callback
{
    if (DIALOG_TYPE_TOAST) {
        UIView *toastView = [self toastView:message type:1];
        [self.view showToast:toastView duration:DIALOG_SHOW_TIME position:CSToastPositionCenter tapCallback:callback];
        [self performSelector:@selector(doCallback:) withObject:callback afterDelay:DIALOG_SHOW_TIME];
    } else {
        NSDictionary *options = @{
                                  kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                  kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypePush),
                                  kCRToastUnderStatusBarKey : @(NO),
                                  kCRToastTextKey : message,
                                  kCRToastFontKey : [UIFont systemFontOfSize:15],
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                                  kCRToastTimeIntervalKey : @(DIALOG_SHOW_TIME),
                                  kCRToastBackgroundColorKey : [UIColor colorWithHexString:@"72e31d"],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom),
                                  kCRToastImageKey : [UIImage imageNamed:@"alert_ok.png"],
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:callback];
    }
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
    loading.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
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
    if (DIALOG_TYPE_TOAST) {
        UIView *toastView = [self toastView:message type:3];
        [self.view showToast:toastView duration:DIALOG_SHOW_TIME position:CSToastPositionCenter];
    } else {
        NSDictionary *options = @{
                                  kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                  kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypePush),
                                  kCRToastUnderStatusBarKey : @(NO),
                                  kCRToastTextKey : message,
                                  kCRToastFontKey : [UIFont systemFontOfSize:15],
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                                  kCRToastTimeIntervalKey : @(DIALOG_SHOW_TIME),
                                  kCRToastBackgroundColorKey : [UIColor colorWithHexString:@"f26e64"],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight),
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:nil];
    }
}

/**
 *  拼装弹窗模板
 *
 *  @param message 消息内容
 *  @param type    消息类型,1成功 2失败 3消息
 *
 *  @return 返回showToast视图
 */
- (UIView *)toastView:(NSString *)message type: (int) type
{
    //主视图
    UIView *toastView = [[UIView alloc] init];
    toastView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    toastView.layer.cornerRadius = 10.0;
    toastView.layer.shadowOpacity = 0.8;
    toastView.layer.shadowRadius = 6.0;
    toastView.layer.shadowOffset = CGSizeMake(4.0, 4.0);
    
    //文本
    UILabel *messageLabel = nil;
    messageLabel = [[UILabel alloc] init];
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont systemFontOfSize:16.0];
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.text = message;
    
    //颜色
    UIColor *bgColor = nil;
    UIColor *textColor = nil;
    UIColor *shadowColor = nil;
    switch (type) {
            //成功
        case 1:
            bgColor = [UIColor colorWithHexString:@"76CF67"];
            textColor = [UIColor colorWithHexString:@"FFFFFF"];
            shadowColor = [UIColor colorWithHexString:@"67B759"];
            break;
            //失败
        case 2:
            bgColor = [UIColor colorWithHexString:@"DD3B41"];
            textColor = [UIColor colorWithHexString:@"FFFFFF"];
            shadowColor = [UIColor colorWithHexString:@"812929"];
            break;
            //警告
        case 3:
            bgColor = [UIColor colorWithHexString:@"DAC43C"];
            textColor = [UIColor colorWithHexString:@"484638"];
            shadowColor = [UIColor colorWithHexString:@"E5D87C"];
            break;
            //消息
        default:
            bgColor = [UIColor colorWithHexString:@"000000"];
            textColor = [UIColor colorWithHexString:@"FFFFFF"];
            shadowColor = [UIColor colorWithHexString:@"000000"];
            break;
    }
    
    toastView.backgroundColor = bgColor;
    toastView.layer.shadowColor = shadowColor.CGColor;
    messageLabel.textColor = textColor;
    
    //高度
    NSArray *messageLines = [message componentsSeparatedByString:@"\n"];
    NSInteger lines = [messageLines count];
    NSInteger height = lines > 1 ? (30 * lines) : 40;
    
    messageLabel.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH * 0.8, height);
    toastView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH * 0.8, height);
    [toastView addSubview:messageLabel];
    
    return toastView;
}

@end
