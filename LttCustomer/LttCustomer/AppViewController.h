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
#import "AppExtension.h"

@interface AppViewController : BaseViewController
{
    //子页面是否有导航返回按钮
    BOOL hasNavBack;
    
    //当前页面是否隐藏返回按钮
    BOOL hideBackButton;
    
    //是否是首页导航栏(背景高亮)
    BOOL isIndexNavBar;
}

//是否登陆
- (BOOL) isLogin;

//是否需要TabBar
- (BOOL) hasTabBar;

//弹出控制器，自动检查登陆
- (void) pushViewController:(AppViewController *)viewController animated: (BOOL)animated;

@end

