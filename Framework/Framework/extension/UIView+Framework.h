//
//  UIView+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/28.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Framework)

- (void) showIndicator;

- (void) hideIndicator;

//获取当前控制器
- (UIViewController *) viewController;

@end
