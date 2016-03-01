//
//  FWApp.m
//  Framework
//
//  Created by wuyong on 16/3/1.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWApp.h"

@implementation FWApp

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
    [FWLog verbose:log];
#endif
    
#if FRAMEWORK_TEST
    //开启测试
    [[FWUnitTest sharedInstance] run];
#endif
}
#endif

//单例对象
@def_singleton(FWApp)

//init
- (id)init
{
    self = [super init];
    if (self) {
        //初始化
    }
    return self;
}

//只读属性
@def_prop_dynamic(id<UIApplicationDelegate>, delegate)
@def_prop_dynamic(UIWindow *, window)

//导航根属性：最内层
@def_prop_dynamic(UIViewController *, rootViewController)

//导航活动属性：最外层
@def_prop_dynamic(UITabBarController *, tabBarController)
@def_prop_dynamic(UINavigationController *, navigationController)
@def_prop_dynamic(UIViewController *, viewController)

- (id<UIApplicationDelegate>)delegate
{
    return [UIApplication sharedApplication].delegate;
}

- (UIWindow *)window
{
    return [UIApplication sharedApplication].keyWindow;
}

- (UIViewController *)rootViewController
{
    return self.window.rootViewController;
}

- (UITabBarController *)tabBarController
{
    UIViewController *rootVC = self.rootViewController;
    //UITabBarController
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)rootVC;
    }
    return nil;
}

- (UINavigationController *)navigationController
{
    UIViewController *rootVC = self.rootViewController;
    //UITabBarController
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        //取选中控制器
        UIViewController *selectedVC = ((UITabBarController *)rootVC).selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)selectedVC;
        }
    //UINavigationController
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    }
    return nil;
}

- (UIViewController *)viewController
{
    UIViewController *rootVC = self.rootViewController;
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
