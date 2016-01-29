//
//  UINavigationController+Framework.m
//  Framework
//
//  Created by wuyong on 16/1/29.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UINavigationController+Framework.h"

@implementation UINavigationController (Framework)

//向上push动画
- (void)addVerticalPushAnimation
{
    CATransition *transiton = [CATransition animation];
    transiton.type = kCATransitionMoveIn;
    transiton.duration = 0.20;
    transiton.subtype = kCATransitionFromTop;
    transiton.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.view.layer addAnimation:transiton forKey:kCATransition];
}

//向下pop动画
- (void)addVerticalPopAnimation
{
    CATransition *transiton = [CATransition animation];
    transiton.type = kCATransitionReveal;
    transiton.duration = 0.20;
    transiton.subtype = kCATransitionFromBottom;
    transiton.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.view.layer addAnimation:transiton forKey:kCATransition];
}

//支持切换方向
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated vertical:(BOOL)vertical
{
    //原生方式
    if (!animated || !vertical) {
        [self pushViewController:viewController animated:animated];
    } else {
        [self addVerticalPushAnimation];
        [self pushViewController:viewController animated:NO];
    }
}

//支持切换方向
- (UIViewController *) popViewControllerAnimated:(BOOL)animated vertical:(BOOL)vertical
{
    //原生方式
    if (!animated || !vertical) {
        return [self popViewControllerAnimated:animated];
    } else {
        [self addVerticalPopAnimation];
        return [self popViewControllerAnimated:NO];
    }
}

//支持切换方向
- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated vertical:(BOOL)vertical
{
    //原生方式
    if (!animated || !vertical) {
        return [self popToViewController:viewController animated:animated];
    } else {
        [self addVerticalPopAnimation];
        return [self popToViewController:viewController animated:NO];
    }
}

//支持切换方向
- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated vertical:(BOOL)vertical
{
    //原生方式
    if (!animated || !vertical) {
        return [self popToRootViewControllerAnimated:animated];
    } else {
        [self addVerticalPopAnimation];
        return [self popToRootViewControllerAnimated:NO];
    }
}

//支持切换方向
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated vertical:(BOOL)vertical
{
    //原生方式
    if (!animated || !vertical) {
        [self setViewControllers:viewControllers animated:animated];
    } else {
        [self addVerticalPushAnimation];
        [self setViewControllers:viewControllers animated:NO];
    }
}

@end
