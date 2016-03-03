//
//  UIView+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/28.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Framework)

//显示加载动画
- (void) showIndicator;

//隐藏加载动画
- (void) hideIndicator;

//获取当前控制器
- (UIViewController *) viewController;

@end
