//
//  TabbarViewController.m
//  LttMember
//
//  Created by wuyong on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "TabbarViewController.h"
#import "HomeViewController.h"
#import "BusinessListViewController.h"
#import "CaseListViewController.h"
#import "AccountViewController.h"
#import "LoginViewController.h"

@interface TabbarViewController () <UITabBarControllerDelegate>

@end

@implementation TabbarViewController

@def_singleton(TabbarViewController)

- (id)init
{
    self = [super init];
    if (self) {
        //修正hidesBottomBarWhenPushed闪烁问题
        [UINavigationController aspect_hookSelector:@selector(pushViewController:animated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, UIViewController *viewController, BOOL animated){
            //自动隐藏tabBar
            viewController.hidesBottomBarWhenPushed = YES;
        } error:nil];
        [UINavigationController aspect_hookSelector:@selector(setViewControllers:animated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, NSArray *viewControllers, BOOL animated){
            //自动隐藏tabBar
            UIViewController *viewController = [viewControllers lastObject];
            viewController.hidesBottomBarWhenPushed = YES;
        } error:nil];
        
        //首页
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        homeNavigationController.title = @"服务";
        homeNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbarHome"];
        homeNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarHomeSelected"];
        
        //微商
        BusinessListViewController *businessViewController = [[BusinessListViewController alloc] init];
        UINavigationController *businessNavigationController = [[UINavigationController alloc] initWithRootViewController:businessViewController];
        businessNavigationController.title = @"微商";
        businessNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbarMerchant"];
        businessNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarMerchantSelected"];
        
        //订单
        CaseListViewController *orderViewController = [[CaseListViewController alloc] init];
        UINavigationController *orderNavigationController = [[UINavigationController alloc] initWithRootViewController:orderViewController];
        orderNavigationController.title = @"订单";
        orderNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbarOrder"];
        orderNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarOrderSelected"];
        
        //账户
        AccountViewController *accountViewController = [[AccountViewController alloc] init];
        UINavigationController *accountNavigationController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
        accountNavigationController.title = @"我";
        accountNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbarAccount"];
        accountNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarAccountSelected"];
        
        //初始化
        self.viewControllers = [NSArray arrayWithObjects:homeNavigationController, businessNavigationController, orderNavigationController, accountNavigationController, nil];
        
        //设置颜色
        self.tabBar.tintColor = COLOR_MAIN_HIGHLIGHT;
        self.tabBar.selectedImageTintColor = COLOR_MAIN_HIGHLIGHT;
        
        //代理为自身
        self.delegate = self;
    }
    return self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([StorageUtil sharedStorage].isLogin) {
        return YES;
    } else {
        [self gotoLogin];
        return NO;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.tabBar.hidden = NO;
}

- (UINavigationController *)selectedNavigationController
{
    UIViewController *selectedViewController = self.selectedViewController;
    if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)selectedViewController;
    } else {
        return selectedViewController.navigationController;
    }
}

- (void)gotoHome
{
    self.selectedIndex = 0;
    self.tabBar.hidden = NO;
}

- (void)gotoBusiness
{
    self.selectedIndex = 1;
    self.tabBar.hidden = NO;
}

- (void)gotoOrder
{
    self.selectedIndex = 2;
    self.tabBar.hidden = NO;
}

- (void)gotoAccount
{
    self.selectedIndex = 3;
    self.tabBar.hidden = NO;
}

- (void)gotoLogin
{
    LoginViewController *viewController = [[LoginViewController alloc] init];
    [self.selectedNavigationController pushViewController:viewController animated:YES];
}

@end
