//
//  AppViewController.h
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "AppExtension.h"
#import "MBProgressHUD.h"
#import "BaseViewController.h"

@interface AppViewController : BaseViewController
{
    //是否显示菜单
    BOOL isMenuEnabled;
    
    //当前页面是否隐藏返回按钮
    BOOL hideBackButton;
    
    //是否是首页导航栏(背景高亮)
    BOOL isIndexNavBar;
    
    //是否隐藏远程通知提示
    BOOL hideRemoteNotification;
}

//回调代码块(某些控制器需要回调上级控制器可以使用此方式实现)
@property (copy) CallbackBlock callbackBlock;

//检查远程通知
- (void) checkRemoteNotification;

- (BOOL) isLogin;

- (void) refreshMenu;

//弹出控制器
- (void) pushViewController:(UIViewController *)viewController animated: (BOOL)animated;

//切换控制器
- (void) toggleViewController:(UIViewController *)viewController animated: (BOOL)animated;

//重载控制器
- (void) refreshViewController: (UIViewController *)viewController animated: (BOOL)animated;

@end
