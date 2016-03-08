//
//  FWScreen.m
//  Framework
//
//  Created by 吴勇 on 16/3/2.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWScreen.h"
#import "FWContext.h"

@implementation FWScreen
{
    CGRect _bounds;
    CGFloat _statusBarHeight;
}

@def_singleton(FWScreen)

//当前控制器
@def_prop_weak(UIViewController *, viewController)

//屏幕边界
@def_prop_dynamic(CGRect, bounds)
@def_prop_dynamic(CGFloat, width)
@def_prop_dynamic(CGFloat, height)

//当前有效边界(自动扣除状态栏，导航栏，TabBar)
@def_prop_dynamic(CGRect, availBounds)
@def_prop_dynamic(CGFloat, availWidth)
@def_prop_dynamic(CGFloat, availHeight)

//组件高度
@def_prop_dynamic(CGFloat, statusBarHeight)
@def_prop_dynamic(CGFloat, navigationBarHeight)
@def_prop_dynamic(CGFloat, tabBarHeight)

//组件有效高度
@def_prop_dynamic(CGFloat, availStatusBarHeight)
@def_prop_dynamic(CGFloat, availNavigationBarHeight)
@def_prop_dynamic(CGFloat, availTabBarHeight)

//组件是否显示
@def_prop_dynamic(BOOL, statusBarHidden)
@def_prop_dynamic(BOOL, navigationBarHidden)
@def_prop_dynamic(BOOL, tabBarHidden)

- (id)init
{
    self = [super init];
    if (self) {
        _bounds = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (CGRect)bounds
{
    return _bounds;
}

- (CGFloat)width
{
    return _bounds.size.width;
}

- (CGFloat)height
{
    return _bounds.size.height;
}

- (CGRect)availBounds
{
    //1. 根据当前组件状态取有效边界
    CGFloat availHeight = _bounds.size.height;
    
    //有导航栏时: -(状态栏+导航栏); 无导航栏时: 不扣除状态栏
    if (self.navigationBarHidden != YES) {
        availHeight -= (self.statusBarHeight + self.navigationBarHeight);
    }
    //有TabBar时: -(TabBar)
    if (self.tabBarHidden != YES) {
        availHeight -= self.tabBarHeight;
    }
    
    return CGRectMake(0, 0, _bounds.size.width, availHeight);
}

- (CGFloat)availWidth
{
    return _bounds.size.width;
}

- (CGFloat)availHeight
{
    return self.availBounds.size.height;
}

- (CGFloat)statusBarHeight
{
    if (_statusBarHeight <= 0) {
        _statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    return _statusBarHeight;
}

- (CGFloat)navigationBarHeight
{
    UINavigationController *navigationController = _viewController ? _viewController.navigationController : [FWContext sharedInstance].navigationController;
    return navigationController ? navigationController.navigationBar.frame.size.height : 0;
}

- (CGFloat)tabBarHeight
{
    UITabBarController *tabBarContoller = _viewController ? _viewController.tabBarController : [FWContext sharedInstance].tabBarController;
    return tabBarContoller ? tabBarContoller.tabBar.frame.size.height : 0;
}

- (CGFloat)availStatusBarHeight
{
    return self.statusBarHidden != YES ? self.statusBarHeight : 0;
}

- (CGFloat)availNavigationBarHeight
{
    return self.navigationBarHidden != YES ? self.navigationBarHeight : 0;
}

- (CGFloat)availTabBarHeight
{
    return self.tabBarHidden != YES ? self.tabBarHeight : 0;
}

- (BOOL)statusBarHidden
{
    return [UIApplication sharedApplication].statusBarHidden;
}

- (BOOL)navigationBarHidden
{
    UINavigationController *navigationController = _viewController ? _viewController.navigationController : [FWContext sharedInstance].navigationController;
    return navigationController ? navigationController.navigationBar.hidden : YES;
}

- (BOOL)tabBarHidden
{
    UITabBarController *tabBarContoller = _viewController ? _viewController.tabBarController : [FWContext sharedInstance].tabBarController;
    return tabBarContoller ? tabBarContoller.tabBar.hidden : YES;
}

@end
