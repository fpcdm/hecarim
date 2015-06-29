//
//  LttAppDelegate.m
//  LttCustomer
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LttAppDelegate.h"
#import "HomeViewController.h"
#import "AppUIUtil.h"
#import "RestKitUtil.h"
#import "LoginViewController.h"

@interface LttAppDelegate ()

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
    
    //初始化控制器
    [self initViewController];
    
    //初始化推送
    [self initPush:launchOptions];
    
    return YES;
}

- (void)initViewController {
    UIViewController *viewController = nil;
    viewController = [[HomeViewController alloc] init];
    
    LttNavigationController *navigationController = [[LttNavigationController alloc] initWithRootViewController:viewController];
    MenuViewController *menuViewController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuViewController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    [self.window makeKeyAndVisible];
    
    //接口错误未登录时跳转登陆界面
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    sharedClient.globalErrorBlock = ^(ErrorEntity *error){
        //跳转登陆
        if (error.code == ERROR_CODE_NOLOGIN) {
            [frostedViewController hideMenuViewController];
            
            //清除用户信息
            [[StorageUtil sharedStorage] setUser:nil];
            
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.tokenExpired = YES;
            [navigationController pushViewController:loginViewController animated:YES];
            return NO;
        }
        return YES;
    };
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

- (void)initPush:(NSDictionary *)launchOptions {
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    //查询DEVICE_TOKEN
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICE_TOKEN"];
    NSLog(@"deviceToken: %@", deviceToken);
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
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
    // 打印到日志
    NSLog(@"Register use deviceToken : %@", deviceToken);
    
    //测试记录token
    if (deviceToken) {
        [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"DEVICE_TOKEN"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Received Remote Notification::\n%@", userInfo);
}

@end
