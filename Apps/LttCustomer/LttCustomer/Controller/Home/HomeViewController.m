//
//  RootViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "CaseFormViewController.h"
#import "LoginViewController.h"
#import "CaseEntity.h"
#import "CaseHandler.h"
#import "HelperHandler.h"
#import "LocationUtil.h"
#import "TimerUtil.h"

//GPS数据缓存，优化GPS耗电
static NSString *lastAddress = nil;
static NSString *detailAddress = nil;
static NSNumber *lastService = nil;
static NSDate   *lastDate    = nil;

@interface HomeViewController () <HomeViewDelegate, LocationUtilDelegate>

@end

@implementation HomeViewController
{
    HomeView *homeView;
    TimerUtil *gpsTimer;
}

- (void)loadView
{
    homeView = [[HomeView alloc] init];
    homeView.delegate = self;
    self.view = homeView;
}

- (void)viewDidLoad
{
    isIndexNavBar = YES;
    isMenuEnabled = [self isLogin];
    hideBackButton = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"两条腿";
    
    //设置定时器
    [self setTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //定位失败，重新定位
    if (!lastAddress) {
        [LocationUtil sharedInstance].delegate = self;
        [[LocationUtil sharedInstance] restartUpdate];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //释放定时器
    if (gpsTimer) {
        [gpsTimer invalidate];
        gpsTimer = nil;
    }
}

//渲染视图
- (void) renderView
{
    [homeView setData:@"address" value:lastAddress ? lastAddress : @"定位失败"];
    [homeView setData:@"count" value:lastService ? lastService : @-1];
    [homeView renderData];
}

- (void) setTimer
{
    //定时器间隔：30秒钟，GPS刷新间隔：1分钟，因为手工GPS会重置最后刷新时间
    gpsTimer = [TimerUtil repeatTimer:(USER_LOCATION_INTERVAL / 2) block:^{
        //定位成功检查GPS刷新间隔
        if (lastAddress) {
            NSTimeInterval timeInterval = [TimerUtil timeInterval:lastDate];
            if (timeInterval > 0 && timeInterval < (USER_LOCATION_INTERVAL - 1)) {
                NSLog(@"未到GPS刷新时间");
                
                //加载缓存数据视图
                [self renderView];
                return;
            }
        }
        
        //记录刷新时间
        lastDate = [NSDate date];
        
        //设置位置代理
        [LocationUtil sharedInstance].delegate = self;
        //刷新一次gps
        [[LocationUtil sharedInstance] restartUpdate];
    } queue:dispatch_get_main_queue()];
}

#pragma mark - GPS
- (void) updateLocationSuccess:(CLLocationCoordinate2D)position
{
    //停止监听GPS
    [[LocationUtil sharedInstance] stopUpdate];
    
    //查询位置
    LocationEntity *locationEntity = [[LocationEntity alloc] init];
    locationEntity.longitude = [NSNumber numberWithFloat:position.longitude];
    locationEntity.latitude = [NSNumber numberWithFloat:position.latitude];
    
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler queryLocation:locationEntity success:^(NSArray *result){
        LocationEntity *location = [result firstObject];
        
        //获取位置
        if (location.address && [location.address length] > 0) {
            lastAddress = location.address;
            detailAddress = location.detailAddress;
        }
        
        //查询信使数量
        [helperHandler queryServiceNumber:locationEntity success:^(NSArray *result){
            LocationEntity *location = [result firstObject];
            
            //获取位置
            if (location.serviceNumber) {
                lastService = location.serviceNumber;
            }
            
            //刷新视图
            [self renderView];
        } failure:^(ErrorEntity *error){
            //刷新视图
            [self renderView];
        }];
    } failure:^(ErrorEntity *error){
        //刷新视图
        [self renderView];
    }];
}

- (void)updateLocationError:(NSError *)error
{
    if (lastAddress) return;
    
    //重置数据
    lastAddress = nil;
    lastService = nil;
    
    //刷新视图
    [self renderView];
}

#pragma mark - Action
- (void)actionGps
{
    //记录刷新时间
    lastDate = [NSDate date];
    
    //设置位置代理
    [LocationUtil sharedInstance].delegate = self;
    //刷新GPS
    [[LocationUtil sharedInstance] restartUpdate];
}

- (void)actionCase:(NSNumber *)type
{
    //是否登陆
    if (![self isLogin]) {
        LoginViewController *viewController = [[LoginViewController alloc] init];
        [self pushViewController:viewController animated:YES];
        return;
    }
    
    //获取参数
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.typeId = type;
    intentionEntity.buyerAddress = detailAddress;
    
    NSLog(@"intention: %@", [intentionEntity toDictionary]);
    
    //跳转表单页面
    CaseFormViewController *viewController = [[CaseFormViewController alloc] init];
    viewController.caseEntity = intentionEntity;
    [self pushViewController:viewController animated:YES];
}

@end