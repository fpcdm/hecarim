//
//  BaseViewController.h
//  LttCustomer
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "AppExtension.h"
#import "RestKitUtil.h"
#import "ValidateUtil.h"
#import "MBProgressHUD.h"
#import "BaseViewController.h"

@interface AppViewController : BaseViewController
{
    //是否禁用菜单
    BOOL isMenuDisabled;
    
    //左侧菜单是否为返回
    BOOL isMenuBack;
}

- (BOOL) checkLogin;
- (void) refreshMenu;

@end

