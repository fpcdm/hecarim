//
//  LttAppDelegate.m
//  LttCustomer
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LttAppDelegate.h"
#import "HomeViewController.h"
#import "AccountViewController.h"
#import "LoginViewController.h"
#import "BPush.h"
#import "AppUIUtil.h"

@interface LttAppDelegate () /*<BPushDelegate>*/

@end

@implementation LttAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
#if TARGET_IPHONE_SIMULATOR
    if (IS_DEBUG) {
        //模拟器开启颜色
        setenv("XcodeColors", "YES", 1);
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
        //自定义颜色
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagInfo];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor grayColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    }
#endif
    
    //全局导航栏颜色
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.barTintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE_BG];
    navigationBar.tintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE];
    navigationBar.titleTextAttributes = @{
                                          NSFontAttributeName:[UIFont systemFontOfSize:SIZE_TITLE_TEXT],
                                          NSForegroundColorAttributeName: [UIColor colorWithHexString:COLOR_MAIN_TITLE]
                                          };
    
    //全局TabBar颜色
    UITabBar *tabBar = [UITabBar appearance];
    tabBar.barTintColor = [UIColor colorWithHexString:COLOR_MAIN_TABBAR_BG];
    tabBar.tintColor = [UIColor colorWithHexString:COLOR_MAIN_TARBAR_HIGHLIGHTED];
    
    //初始化控制器
    [self initViewController];
    
    //初始化百度推送
    //[self initBPush:launchOptions];
    
    return YES;
}

- (void)initViewController {
    //1
    HomeViewController *firstViewController = [[HomeViewController alloc] init];
    UINavigationController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    firstNavigationController.title = @"首页";
    firstNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbar"];
    
    //2
    UIViewController *secondViewController = [[UIViewController alloc] init];
    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    secondNavigationController.title = @"发现";
    secondNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbar"];
    
    //3
    UIViewController *thirdViewController = [[UIViewController alloc] init];
    UINavigationController *thirdNavigationController = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    thirdNavigationController.title = @"服务单";
    thirdNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbar"];
    
    //4
    AccountViewController *forthViewController = [[AccountViewController alloc] init];
    UINavigationController *forthNavigationController = nil;
    //是否登陆
    if ([forthViewController isLogin]) {
        forthNavigationController = [[UINavigationController alloc] initWithRootViewController:forthViewController];
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.returnController = forthViewController;
        forthNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    }
    forthNavigationController.title = @"账户";
    forthNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbar"];
    
    //TabBar
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:firstNavigationController, secondNavigationController, thirdNavigationController, forthNavigationController, nil];
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

/*
- (void)initBPush:(NSDictionary *)launchOptions {
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:BAIDU_PUSH_APIKEY pushMode:BPushModeDevelopment isDebug:YES];
    
    // 设置 BPush 的回调
    [BPush setDelegate:self];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 打印到日志
    NSLog(@"background: %@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
    
    // 打印到日志
    NSLog(@"Register use deviceToken : %@", deviceToken);
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    
    NSLog(@"Received Remote Notification::\n%@", userInfo);
}

#pragma mark Push Delegate
- (void)onMethod:(NSString*)method response:(NSDictionary*)data
{
    NSLog(@"Method: %@\n%@", method, data);
}
*/

@end
