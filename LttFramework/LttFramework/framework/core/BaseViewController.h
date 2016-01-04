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

//回调代码块(某些控制器需要回调上级控制器可以使用此方式实现)
@property (copy) CallbackBlock callbackBlock;

//标记自动刷新，viewWillAppear后自动调用
@property (assign, nonatomic) BOOL shouldRefresh;

//刷新数据方法，viewWillAppear自动调用
- (void) refreshHandler;

//检查网络
- (BOOL) checkNetwork;

//加载数据通用方法，完成后执行回调，不自动调用
- (void) loadData: (CallbackBlock) success failure: (CallbackBlock) failure;

//切换self.view视图,类似push效果
- (void) pushView: (UIView *) view animated: (BOOL) animated completion: (void (^)())completion;

//切换self.view视图,类似pop效果
- (void) popView: (UIView *) view animated: (BOOL) animated completion: (void (^)()) completion;

@end
