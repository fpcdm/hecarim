//
//  LttAppDelegate.h
//  LttMember
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LttNavigationController.h"

@interface LttAppDelegate : UIResponder <UIApplicationDelegate, REFrostedViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

//清空服务端消息数量
- (void) clearNotifications;

//处理充值结果回调
- (void) rechargeCallback:(LttPayStatus)status message:(NSString *)message;

@end

