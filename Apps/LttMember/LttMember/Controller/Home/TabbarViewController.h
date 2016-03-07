//
//  TabbarViewController.h
//  LttMember
//
//  Created by wuyong on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarViewController : UITabBarController

@singleton(TabbarViewController)

//当前选中的导航栏
- (UINavigationController *)selectedNavigationController;

//刷新菜单
- (void)refreshMenu;

//跳转首页
- (void)gotoHome;

//跳转订单
- (void)gotoOrder;

//跳转微商
- (void)gotoBusiness;

//跳转账户
- (void)gotoAccount;

//跳转登陆
- (void)gotoLogin;

@end
