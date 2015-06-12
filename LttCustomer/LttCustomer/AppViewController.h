//
//  BaseViewController.h
//  LttCustomer
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Config.h"
#import "AppUIUtil.h"

@interface AppViewController : BaseViewController
{
    //是否显示TabBar
    BOOL showTabBar;
    
    //是否有返回按钮(子页面生效)
    BOOL hasBackButton;
    
    //是否是首页导航栏(背景高亮)
    BOOL isIndexNavBar;
}

//是否需要登陆才能访问
- (BOOL) needLogin;

//是否登陆
- (BOOL) isLogin;

//跳转控制器，自动判断登陆
- (void) pushAppViewController:(AppViewController *)viewController animated:(BOOL)animated;

@end

