//
//  UIViewController+Ltt.h
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Ltt)

- (void) showError: (NSString *) message;
- (void) showSuccess: (NSString *) message;
- (void) showLoading: (NSString *) message;
- (void) loadingSuccess: (NSString *) message;
- (void) hideLoading;
- (void) showNotification: (NSString *) message;

@end;
