//
//  BaseViewController.h
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Ltt.h"
#import "FrameworkConfig.h"

//控制器回调函数
typedef void (^CallbackBlock)(id object);

@interface BaseViewController : UIViewController

- (BOOL) checkNetwork;

//回调代码块(某些控制器需要回调上级控制器可以使用此方式实现)
@property (copy) CallbackBlock callbackBlock;

@end
