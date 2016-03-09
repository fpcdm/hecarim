//
//  FWPluginLoading.h
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWPlugin.h"

@protocol FWPluginLoading <FWPlugin>

//显示加载条
- (void)showLoadingInViewController:(UIViewController *)viewController message:(NSString *)message;

//显示加载完成
- (void)finishLoadingInViewController:(UIViewController *)viewController message:(NSString *)message callback:(void(^)())callback;

//隐藏加载条
- (void)hideLoadingInViewController:(UIViewController *)viewController;

@end
