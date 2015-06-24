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
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "AppExtension.h"
#import "IntentionEntity.h"
#import "TimerUtil.h"
#import "NotificationUtil.h"
#import "BPush.h"
#import "IntentionHandler.h"

@interface LttAppDelegate () <BPushDelegate>

@end

@implementation LttAppDelegate
{
    TimerUtil *timer;
    //最新需求Id
    NSNumber *latestIntentionId;
}

@synthesize locationManager, lastCoordinate;

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
    
    UIViewController *viewController = nil;
    //是否登录
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (!user) {
        viewController = [[LoginViewController alloc] init];
    } else {
        viewController = [[HomeViewController alloc] init];
    }
    
    LttNavigationController *navigationController = [[LttNavigationController alloc] initWithRootViewController:viewController];
    MenuViewController *menuViewController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuViewController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //初始化坐标为0
    lastCoordinate = CLLocationCoordinate2DMake(0, 0);
    
    //初始化GPS
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    locationManager.delegate = self;
    if (IS_IOS8_PLUS) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    NSLog(@"start gps");
    
    //取消本地通知
    [NotificationUtil cancelLocalNotifications];
    
    //创建一个多线程，监听抢单列表
    //timer = [TimerUtil repeatTimer:SCHEDULED_TIME_INTERVAL block:^(void){
    //    [self scheduledJob];
    //}];
    
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
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //code
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //code
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //结束定时器
    if (timer) {
        NSLog(@"结束定时器");
        [timer invalidate];
    }
}

//前台通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //顶部通知
    NSString *alertBody = [notification.userInfo objectForKey:SCHEDULED_USERINFO_KEY];
    REFrostedViewController *frostedViewController = (REFrostedViewController *) self.window.rootViewController;
    LttNavigationController *navigationController = (LttNavigationController *) frostedViewController.contentViewController;
    UIViewController *viewController = [navigationController.viewControllers objectAtIndex:0];
    [viewController showNotification:alertBody];
    
    //执行回调
    [NotificationUtil receiveLocalNotification:notification];
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

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didHideMenuViewController");
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    //更新位置
    lastCoordinate = [newLocation coordinate];
    
    NSLog(@"gps success: 经度: %lf 纬度: %lf", lastCoordinate.longitude, lastCoordinate.latitude);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    //重置位置
    lastCoordinate.longitude = 0;
    lastCoordinate.latitude = 0;
    
    NSString *errorMsg = ([error code] == kCLErrorDenied) ? @"访问被拒绝" : @"获取地理位置失败";
    NSLog(@"gps error:%@", errorMsg);
}

//定时任务
- (void) scheduledJob
{
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (!user) return;
    
    NSLog(@"定时刷新抢单");
    
    NSDictionary *param = @{@"location":[NSString stringWithFormat:@"%f,%f", self.lastCoordinate.longitude, self.lastCoordinate.latitude]};
    
    //调用接口
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    [intentionHandler queryIntentions:param success:^(NSArray *result){
        NSLog(@"定时器数据：%@", result);
        
        //有结果且需求id增大
        if ([result count] > 0) {
            IntentionEntity *intention = [result lastObject];
            if (latestIntentionId == nil || [intention.id compare:latestIntentionId] == NSOrderedDescending) {
                latestIntentionId = intention.id;
                
                NSLog(@"定时器结果：新需求id: %@", latestIntentionId);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //注册本地通知
                    [NotificationUtil registerLocalNotification:SCHEDULED_USERINFO_KEY alertBody:LocalString(@"TIP_INTENTION_COME") time:1];
                });
            }
        }
    } failure:^(ErrorEntity *error){}];
}

@end
