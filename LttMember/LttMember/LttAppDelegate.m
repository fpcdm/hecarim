//
//  LttAppDelegate.m
//  LttMember
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LttAppDelegate.h"
#import "HomeViewController.h"
#import "AppUIUtil.h"
#import "RestKitUtil.h"
#import "LoginViewController.h"
#import "DeviceEntity.h"
#import "UserHandler.h"
#import "NotificationUtil.h"
#import "TimerUtil.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

@interface LttAppDelegate ()

@end

@implementation LttAppDelegate
{
    REFrostedViewController *frostedViewController;
    LttNavigationController *navigationController;
    
    TimerUtil *heartbeatTimer;
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
    //iOS6兼容
    if ([navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        navigationBar.barTintColor = [UIColor colorWithHexString:@"F8F8F8"];
    }
    navigationBar.tintColor = COLOR_MAIN_BLACK;
    navigationBar.titleTextAttributes = @{
                                          NSFontAttributeName:[UIFont systemFontOfSize:20],
                                          NSForegroundColorAttributeName: COLOR_MAIN_BLACK
                                          };
    
    //初始化客户端类型
    [[RestKitUtil sharedClient] setClientType:LTT_CLIENT_TYPE];
    
    //检查城市缓存
    NSString *cityCode = [[StorageUtil sharedStorage] getCityCode];
    if (cityCode) {
        [[RestKitUtil sharedClient] setCityCode:cityCode];
    }
    
    //调试功能
#ifdef LTT_DEBUG
    if (IS_DEBUG) {
        NSString *server = [[StorageUtil sharedStorage] getData:DEBUG_LTT_REST_SERVER_KEY];
        if (server) {
            [[RestKitUtil sharedClient] setBaseUrl:[NSURL URLWithString:server]];
        }
    }
#endif
    
    //初始化控制器
    [self initViewController];
    
    //初始化推送
    [self initPush:launchOptions];
    
    //初始化心跳
    [self initHeartbeat];
    
    //初始化友盟分享
    [self initUmeng];
    
    return YES;
}

- (void)initViewController {
    UIViewController *viewController = nil;
    viewController = [[HomeViewController alloc] init];
    
    navigationController = [[LttNavigationController alloc] initWithRootViewController:viewController];
    MenuViewController *menuViewController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuViewController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = COLOR_MAIN_BG;
    [self.window makeKeyAndVisible];
    
    //接口错误未登录时跳转登陆界面
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    sharedClient.globalErrorBlock = ^(ErrorEntity *error){
        //跳转登陆
        if (error.code == ERROR_CODE_NOLOGIN) {
            [frostedViewController hideMenuViewController];
            
            //清除用户信息
            [[StorageUtil sharedStorage] setUser:nil];
            [[StorageUtil sharedStorage] setRemoteNotification:nil];
            
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
    //处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
    [UMSocialSnsService applicationDidBecomeActive];
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
    [self addDevice:deviceTokenStr];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
    
    //模拟deviceToken，可以接单
    if (IS_DEBUG && IS_IPHONE_SIMULATOR) {
        NSString* deviceTokenStr = @"2a9696cfe2264871e54fed9c22969a23e9095fb9bbcf459f3c58d7bf0c4b9779";
        [self addDevice:deviceTokenStr];
    }
}

//添加设备到服务器，并记录设备id
- (void) addDevice: (NSString *) deviceToken
{
    // 记录设备token
    if (deviceToken && [deviceToken length] > 0) {
        //新增设备接口
        DeviceEntity *device = [[DeviceEntity alloc] init];
        device.token = deviceToken;
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
        [viewController isKindOfClass:[AppViewController class]]) {
        [(AppViewController *) viewController checkRemoteNotification];
    }
}

/**
 *  初始化心跳
 */
- (void) initHeartbeat
{
    heartbeatTimer = [TimerUtil repeatTimer:USER_HEARTBEAT_INTERVAL block:^{
        //用户是否登陆
        UserEntity *user = [[StorageUtil sharedStorage] getUser];
        if (user) {
            NSLog(@"更新用户心跳");
            
            UserHandler *userHandler = [[UserHandler alloc] init];
            [userHandler updateHeartbeat:user param:nil success:^(NSArray *result){
                NSLog(@"更新用户心跳成功");
            } failure:^(ErrorEntity *error){
                NSLog(@"更新用户心跳失败");
            }];
        }
    }];
}

//初始化友盟分享
- (void)initUmeng
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMENG_SHARE_APPKEY];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:UMENG_WEIXIN_APPID appSecret:UMENG_WEIXIN_APPKEY url:UMENG_SHARE_URL];
    
    // 打开新浪微博的SSO开关，并配置应用appkey、redirectURL，redirectURL需和后台设置保持一致
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:UMENG_SINA_APPKEY RedirectURL:UMENG_SINA_REDIRECTURL];
    
    //设置分享到QQ空间的应用Id，和分享url链接，并设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setQQWithAppId:UMENG_QQ_APPID appKey:UMENG_QQ_APPKEY url:UMENG_SHARE_URL];
    [UMSocialQQHandler setSupportWebView:YES];
}

//友盟回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK
    }
    return result;
}

@end
