//
//  UINavigationController+Vertical.m
//  LttMember
//
//  Created by wuyong on 15/11/10.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "UINavigationController+Vertical.h"

@implementation UINavigationController (Vertical)

//支持切换方向
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated vertical:(BOOL)vertical
{
    //原生方式
    if (!animated || !vertical) {
        [self pushViewController:viewController animated:animated];
    } else {
        CATransition *transiton = [CATransition animation];
        transiton.type = kCATransitionMoveIn;
        transiton.duration = 0.20;
        transiton.subtype = kCATransitionFromTop;
        transiton.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.view.layer addAnimation:transiton forKey:kCATransition];
        
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
        CATransition *transiton = [CATransition animation];
        transiton.type = kCATransitionReveal;
        transiton.duration = 0.20;
        transiton.subtype = kCATransitionFromBottom;
        transiton.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.view.layer addAnimation:transiton forKey:kCATransition];
        
        return [self popViewControllerAnimated:NO];
    }
}

@end
