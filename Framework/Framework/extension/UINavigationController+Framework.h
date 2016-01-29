//
//  UINavigationController+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/29.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Framework)

//支持切换方向
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated vertical:(BOOL)vertical;

//支持切换方向
- (UIViewController *) popViewControllerAnimated:(BOOL)animated vertical:(BOOL)vertical;

//支持切换方向
- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated vertical:(BOOL)vertical;

//支持切换方向
- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated vertical:(BOOL)vertical;

//支持切换方向
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated vertical:(BOOL)vertical;

@end
