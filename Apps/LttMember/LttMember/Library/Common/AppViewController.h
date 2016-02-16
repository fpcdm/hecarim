//
//  BaseViewController.h
//  LttMember
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Config.h"
#import "AppUIUtil.h"
#import "AppExtension.h"

@interface AppViewController : BaseViewController
{
    //是否显示菜单
    BOOL isMenuEnabled;
    
    //是否禁用菜单手势
    BOOL disableMenuGesture;
    
    //是否隐藏导航栏
    BOOL hideNavigationBar;
    
    //当前页面是否隐藏返回按钮
    BOOL hideBackButton;
    
    //是否是首页导航栏(背景高亮)
    BOOL isIndexNavBar;
    
    //是否是首页状态栏
    BOOL isIndexStatusBar;
    
    //是否隐藏远程通知提示
    BOOL hideRemoteNotification;
}

//检查远程通知
- (void) checkRemoteNotification;

//处理远程通知钩子（默认顶部弹出框）
- (void) handleRemoteNotification:(NSString *) message type: (NSString *) type data: (NSString *) data;

//刷新菜单
- (void) refreshMenu;

//是否登陆
- (BOOL) isLogin;

//弹出控制器，自动检查登陆
- (void) pushViewController:(AppViewController *)viewController animated: (BOOL)animated;

//切换控制器（仅剩一个），自动检查登陆
- (void) toggleViewController:(AppViewController *)viewController animated: (BOOL)animated;

//替换当前控制器（替换最后一个），自动检查登陆
- (void) replaceViewController:(AppViewController *)viewController animate: (BOOL)animated;

@end

