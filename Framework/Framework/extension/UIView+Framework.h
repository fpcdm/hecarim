//
//  UIView+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/28.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWSignal.h"

@interface UIView (Framework)

- (void) showIndicator;

- (void) hideIndicator;

//获取当前控制器
- (UIViewController *) viewController;

//发送信号
- (void) sendSignal:(NSString *)name;

- (void) sendSignal:(NSString *)name withObject:(NSObject *)object;

- (void) sendSignal:(NSString *)name withObject:(NSObject *)object from:(id)source;

- (void) sendSignal:(NSString *)name withObject:(NSObject *)object to:(id)target;

@end
