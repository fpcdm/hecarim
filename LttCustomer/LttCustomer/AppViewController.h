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
    //是否隐藏TabBar
    BOOL hideTabBar;
    
    //是否含有返回按钮
    BOOL showBackBar;
}

- (BOOL) checkLogin;

@end

