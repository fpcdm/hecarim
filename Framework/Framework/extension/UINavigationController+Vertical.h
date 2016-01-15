//
//  UINavigationController+Vertical.h
//  LttMember
//
//  Created by wuyong on 15/11/10.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Vertical)

//支持切换方向
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated vertical:(BOOL)vertical;

//支持切换方向
- (UIViewController *) popViewControllerAnimated:(BOOL)animated vertical:(BOOL)vertical;

@end
