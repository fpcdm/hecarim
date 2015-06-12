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

- (BOOL) checkLogin;

@end

