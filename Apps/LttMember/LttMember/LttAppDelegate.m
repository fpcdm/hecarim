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
#import "LoginViewController.h"
#import "CaseListViewController.h"
#import "AccountViewController.h"
#import "DeviceEntity.h"
#import "UserHandler.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "RechargeViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Harpy.h"
#import "FWDebug.h"

@interface LttAppDelegate () <WXApiDelegate, UITabBarControllerDelegate>

@end

@implementation LttAppDelegate
{
    UITabBarController *tabBarController;
    
    TimerUtil *heartbeatTimer;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //初始化调试工具
    [[FWDebug sharedInstance] benchmarkStart:@"START"];
    
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
    
    //初始化控制器
    [self initViewController];
    
    //初始化推送
    [self initPush:launchOptions];
    
    //初始化心跳
    [self initHeartbeat];
    
    //初始化友盟分享
    [self initUmeng];
    
    //初始化支付
    [self initPay];
    
    //检查版本更新
    [self checkUpdate];
    
    //标记启动结束
    [[FWDebug sharedInstance] benchmarkEnd:@"START"];
    
    return YES;
}

- (void)initViewController {
    //修正hidesBottomBarWhenPushed闪烁问题
    [UINavigationController aspect_hookSelector:@selector(pushViewController:animated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, UIViewController *viewController, BOOL animated){
        //自动隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    } error:nil];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    homeNavigationController.title = @"服务";
    homeNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbarHome"];
    homeNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarHomeSelected"];
    
    CaseListViewController *caseViewController = [[CaseListViewController alloc] init];
    UINavigationController *caseNavigationController = [[UINavigationController alloc] initWithRootViewController:caseViewController];
    caseNavigationController.title = @"订单";
    caseNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbarOrder"];
    caseNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarOrderSelected"];
    
    AccountViewController *accountViewController = [[AccountViewController alloc] init];
    UINavigationController *accountNavigationController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
    accountNavigationController.title = @"我";
    accountNavigationController.tabBarItem.image = [UIImage imageNamed:@"tabbarAccount"];
    accountNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarAccountSelected"];
    
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.tintColor = [UIColor colorWithHex:@"#33BC07"];
    tabBarController.tabBar.selectedImageTintColor = [UIColor colorWithHex:@"#33BC07"];
    tabBarController.delegate = self;
    tabBarController.viewControllers = [NSArray arrayWithObjects:homeNavigationController, caseNavigationController, accountNavigationController, nil];
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = COLOR_MAIN_BG;
    [self.window makeKeyAndVisible];
    
    //接口错误未登录时跳转登陆界面
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    sharedClient.globalErrorBlock = ^(ErrorEntity *error){
        //跳转登陆
        if (error.code == ERROR_CODE_NOLOGIN) {
            //清除用户信息
            [[StorageUtil sharedStorage] setUser:nil];
            [[StorageUtil sharedStorage] setRemoteNotification:nil];
            
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.tokenExpired = YES;
            
            UINavigationController *navigationController = (UINavigationController *) tabBarController.selectedViewController;
            [navigationController pushViewController:loginViewController animated:YES];
            return NO;
        }
        return YES;
    };
}

- (BOOL)tabBarController:(UITabBarController *)_tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //用户是否登陆
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (user) {
        return YES;
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        UINavigationController *navigationController = (UINavigationController *) tabBarController.selectedViewController;
        [navigationController pushViewController:loginViewController animated:YES];
        return NO;
    }
}

- (void)tabBarController:(UITabBarController *)_tabBarController didSelectViewController:(UIViewController *)viewController
{
    tabBarController.tabBar.hidden = NO;
}

- (void)checkUpdate
{
    [[Harpy sharedInstance] setAppID:LTT_APPSTORE_ID];
    [[Harpy sharedInstance] setPresentingViewController:self.window.rootViewController];
    
    [[Harpy sharedInstance] checkVersionWeekly];
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
    UINavigationController *navigationController = (UINavigationController *) tabBarController.selectedViewController;
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
    
    //隐藏没有安装的平台
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina]];
}

//初始化支付
- (void)initPay
{
    //初始化微信支付
    [WXApi registerApp:UMENG_WEIXIN_APPID withDescription:@"两条腿"];
}

//第三方回调，9.0之前
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK
        
        //微信支付回调
        if ([WXApi handleOpenURL:url delegate:self]) {
            return YES;
        }
        
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            //支付宝返回结果（实际结果看账户余额或订单状态）
            LttPayStatus status = LttPayStatusFailed;
            NSString *message = nil;
            if ([resultDic[@"resultStatus"] intValue] == 9000) {
                status = LttPayStatusSuccess;
                NSLog(@"充值成功");
            } else if ([resultDic[@"resultStatus"] intValue] == 6001) {
                status = LttPayStatusCanceled;
                NSLog(@"充值取消");
            } else {
                status = LttPayStatusFailed;
                message = [NSString stringWithFormat:@"(%@-%@)", resultDic[@"resultStatus"], resultDic[@"memo"]];
                NSLog(@"充值失败:%@", message);
            }
            
            //统一处理回调
            [self rechargeCallback:status message:message];
        }];
        return YES;
    }
    return result;
}

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //微信返回结果（实际结果看账户余额或订单状态）
        LttPayStatus status = LttPayStatusFailed;
        NSString *message = nil;
        
        switch (resp.errCode) {
            case WXSuccess:
                status = LttPayStatusSuccess;
                NSLog(@"充值成功:%d", resp.errCode);
                break;
            case WXErrCodeUserCancel:
                status = LttPayStatusCanceled;
                NSLog(@"充值取消:%d", resp.errCode);
                break;
            default:
                status = LttPayStatusFailed;
                message = [NSString stringWithFormat:@"(%d-%@)", resp.errCode, resp.errStr];
                NSLog(@"充值失败:%@", message);
                break;
        }
        
        //统一处理回调
        [self rechargeCallback:status message:message];
    }
}

- (void)onReq:(BaseReq *)req {
}

//充值统一回调
- (void)rechargeCallback:(LttPayStatus)status message:(NSString *)message
{
    NSString *title = @"充值结果";
    switch (status) {
        case LttPayStatusSuccess:
            message = @"充值成功！";
            break;
        case LttPayStatusCanceled:
            message = @"充值取消！";
            break;
        default:
            //正式环境不提示错误原因
            if (IS_DEBUG) {
                message = [NSString stringWithFormat:@"充值失败！%@", message];
            } else {
                message = @"充值失败！";
            }
            break;
    }
    
    //判断是否在充值页面
    UINavigationController *navigationController = (UINavigationController *) tabBarController.selectedViewController;
    UIViewController *viewController = [navigationController.viewControllers count] > 0 ? navigationController.viewControllers.lastObject : nil;
    if (viewController && [viewController isKindOfClass:[RechargeViewController class]]) {
        if (status == LttPayStatusSuccess) {
            [viewController showSuccess:message];
        } else {
            [viewController showError:message];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
