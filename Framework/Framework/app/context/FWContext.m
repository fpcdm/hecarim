//
//  FWContext.m
//  Framework
//
//  Created by wuyong on 16/3/1.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWContext.h"
#import "FWPlugin.h"

@implementation FWContext

//调试模式自动启动日志和单元测试
#if FRAMEWORK_DEBUG
+ (void)load
{
#if FRAMEWORK_LOG
    //开启LOG
    NSArray *opts = @[@"NO", @"YES"];
    NSString *log = [NSString stringWithFormat:@"\n\n\
========== FRAMEWORK ==========\n\
 VERSION : %@\n\
   DEBUG : %@\n\
    TEST : %@\n\
     LOG : %@\n\
========== FRAMEWORK ==========\n",
                     FRAMEWORK_VERSION,
                     opts[FRAMEWORK_DEBUG],
                     opts[FRAMEWORK_TEST],
                     opts[FRAMEWORK_LOG]
                     ];
    [FWLog debug:log];
#endif
    
#if FRAMEWORK_TEST
    //开启测试
    [[FWTest sharedInstance] run];
#endif
    
#if FRAMEWORK_LOG
    //调试插件
    [[FWPluginManager sharedInstance] loadPlugins];
    
    //todo: 调试服务
#endif
}
#endif

//单例对象
@def_singleton(FWContext)

//init
- (id)init
{
    self = [super init];
    if (self) {
        //初始化
    }
    return self;
}

//导航根属性：最内层
@def_prop_dynamic(UIWindow *, window)

//导航活动属性：最外层
@def_prop_dynamic(UITabBarController *, tabBarController)
@def_prop_dynamic(UINavigationController *, navigationController)
@def_prop_dynamic(UIViewController *, viewController)

- (UIWindow *)window
{
    return [UIApplication sharedApplication].keyWindow;
}

- (UITabBarController *)tabBarController
{
    UIViewController *rootVC = self.window.rootViewController;
    //UITabBarController
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)rootVC;
    //UINavigationController
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)rootVC).tabBarController;
    //UIViewController
    } else {
        return rootVC.tabBarController;
    }
    return nil;
}

- (UINavigationController *)navigationController
{
    UIViewController *rootVC = self.window.rootViewController;
    //UITabBarController
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        //取选中控制器
        UIViewController *selectedVC = ((UITabBarController *)rootVC).selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)selectedVC;
        } else {
            return selectedVC.navigationController;
        }
    //UINavigationController
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    //UIViewController
    } else {
        return rootVC.navigationController;
    }
    return nil;
}

- (UIViewController *)viewController
{
    UIViewController *rootVC = self.window.rootViewController;
    //UITabBarController
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        //取选中控制器
        UIViewController *selectedVC = ((UITabBarController *)rootVC).selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            //取导航栏最后一个
            NSArray *viewControllers = ((UINavigationController *)selectedVC).viewControllers;
            if (viewControllers.count > 0) {
                return [viewControllers lastObject];
            }
        } else {
            return selectedVC;
        }
    //UINavigationController
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        //取导航栏最后一个
        NSArray *viewControllers = ((UINavigationController *)rootVC).viewControllers;
        if (viewControllers.count > 0) {
            return [viewControllers lastObject];
        }
    //UIViewController
    } else {
        return rootVC;
    }
    return nil;
}

@end
