//
//  LttAppDelegate.m
//  LttMerchant
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LttAppDelegate.h"
#import "LttNavigationController.h"
#import "MenuViewController.h"
#import "LoginViewController.h"
#import "HomeActivity.h"
#import "AppExtension.h"
#import "IntentionEntity.h"
#import "NotificationUtil.h"
#import "IntentionHandler.h"
#import "UserHandler.h"
#import "LocationUtil.h"
#import "TimerUtil.h"

@interface LttAppDelegate () <LocationUtilDelegate>

@end

@implementation LttAppDelegate
{
    REFrostedViewController *frostedViewController;
    LttNavigationController *navigationController;
    
    TimerUtil *heartbeatTimer;
    LocationUtil *locationUtil;
    NSDate *lastLocationDate;
}

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
    if ([navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        navigationBar.barTintColor = COLOR_MAIN_WHITE;
    }
    navigationBar.tintColor = COLOR_MAIN_BLACK;
    navigationBar.titleTextAttributes = @{
                                          NSFontAttributeName:[UIFont systemFontOfSize:20],
                                          NSForegroundColorAttributeName: COLOR_MAIN_BLACK
                                          };
    
    //初始化客户端类型
    [[RestKitUtil sharedClient] setClientType:LTT_CLIENT_TYPE];
    
    UIViewController *viewController = nil;
    //是否登录
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (!user) {
        viewController = [[LoginViewController alloc] init];
    } else {
        viewController = [[HomeActivity alloc] init];
    }
    
    navigationController = [[LttNavigationController alloc] initWithRootViewController:viewController];
    MenuViewController *menuViewController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuViewController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
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
    
    //初始化推送
    [self initPush:application launchOptions:launchOptions];
    
    //初始化用户心跳
    [self initHeartbeat];
    
    return YES;
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

- (void)clearNotifications
{
    NSString *deviceId = [[StorageUtil sharedStorage] getDeviceId];
    if (deviceId && [deviceId length] > 0) {
        DeviceEntity *device = [[DeviceEntity alloc] init];
        device.id = deviceId;
        
        UserHandler *userHandler = [[UserHandler alloc] init];
        [userHandler clearNotifications:device success:^(NSArray *result){} failure:^(ErrorEntity *error){}];
    }
}

- (void)initPush:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        
        [self handleRemoteNotification:userInfo];
    }
    
    //启动后清空消息计数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self clearNotifications];
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
    
    [self handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@", deviceToken];
    deviceTokenStr = [deviceTokenStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 打印到日志
    NSLog(@"Register use deviceToken : %@", deviceTokenStr);
    
    // 记录设备token
    if (deviceTokenStr && [deviceTokenStr length] > 0) {
        //新增设备接口
        DeviceEntity *device = [[DeviceEntity alloc] init];
        device.token = deviceTokenStr;
        device.type = @"ios";
        
        NSLog(@"注册device: %@", [device toDictionary]);
        
        UserHandler *userHandler = [[UserHandler alloc] init];
        [userHandler addDevice:device success:^(NSArray *result){
            DeviceEntity *resultDevice = [result firstObject];
            
            NSLog(@"注册device成功：%@", resultDevice.id);
            
            //保存设备ID
            [[StorageUtil sharedStorage] setDeviceId:resultDevice.id];
        } failure:^(ErrorEntity *error){
            NSLog(@"注册device失败：%@", error.message);
            
        }];
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
    
    [self handleRemoteNotification:userInfo];
}

// 处理远程通知
- (void)handleRemoteNotification: (NSDictionary *)userInfo
{
    // 保存数据
    [NotificationUtil receiveRemoteNotification:userInfo];
    
    // 及时检查通知
    UIViewController *viewController = [navigationController.viewControllers lastObject];
    if (viewController && [viewController isViewLoaded] &&
        [viewController respondsToSelector:@selector(checkRemoteNotification)]) {
        [(AppViewController *) viewController checkRemoteNotification];
    }
}

/**
 *  初始化心跳
 */
- (void) initHeartbeat
{
    //初始化GPS
    locationUtil = [LocationUtil sharedInstance];
    locationUtil.delegate = self;
    
    //初始化定时器
    heartbeatTimer = [TimerUtil repeatTimer:USER_HEARTBEAT_INTERVAL block:^{
        //检查GPS刷新间隔
        NSTimeInterval timeInterval = [TimerUtil timeInterval:lastLocationDate];
        if (timeInterval > 0 && timeInterval < (USER_LOCATION_INTERVAL - 1)) {
            NSLog(@"未到GPS刷新时间");
        } else {
            //记录刷新时间
            lastLocationDate = [NSDate date];
            
            //刷新一次gps
            [locationUtil startUpdate];
        }
        
        //用户是否登陆
        UserEntity *user = [[StorageUtil sharedStorage] getUser];
        if (user) {
            NSLog(@"更新用户心跳");
            
            //获取gps位置
            CLLocationCoordinate2D position = [locationUtil position];
            NSString *location = [NSString stringWithFormat:@"%f,%f", position.longitude, position.latitude];
            NSDictionary *param = @{@"position": location};
            
            UserHandler *userHandler = [[UserHandler alloc] init];
            [userHandler updateHeartbeat:user param:param success:^(NSArray *result){
                NSLog(@"更新用户心跳成功");
            } failure:^(ErrorEntity *error){
                NSLog(@"更新用户心跳失败");
            }];
        }
    }];
}

#pragma mark - GPS
- (void) updateLocationSuccess:(CLLocationCoordinate2D)position
{
    //停止监听GPS
    [locationUtil stopUpdate];
}

- (void)updateLocationError:(NSError *)error
{
    //停止监听GPS
    [locationUtil stopUpdate];
}

@end
