//
//  UIView+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/28.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Framework)

//Additions
@prop_assign(CGFloat, top)
@prop_assign(CGFloat, bottom)
@prop_assign(CGFloat, left)
@prop_assign(CGFloat, right)

@prop_assign(CGFloat, centerX)
@prop_assign(CGFloat, centerY)

@prop_assign(CGFloat, width)
@prop_assign(CGFloat, height)

//显示加载动画
- (void) showIndicator;

//隐藏加载动画
- (void) hideIndicator;

//获取当前控制器
- (UIViewController *) viewController;

@end
