//
//  RootViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "CaseViewController.h"
#import "LoginViewController.h"
#import "CaseEntity.h"
#import "CaseHandler.h"
#import <CoreLocation/CoreLocation.h>
#import "UserHandler.h"

@interface HomeViewController () <HomeViewDelegate, CLLocationManagerDelegate>

@end

@implementation HomeViewController
{
    CLLocationManager *locationManager;
    NSDate *lastDate;
    
    HomeView *homeView;
    UserHandler *userHandler;
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
    
    [self actionGps];
    
    //todo: 服务人数
    [homeView setData:@"count" value:@12];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (locationManager) {
        [locationManager startUpdatingLocation];
        NSLog(@"start gps");
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (locationManager) {
        [locationManager stopUpdatingLocation];
        NSLog(@"stop gps");
    }
}

#pragma mark - GPS
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    //请求间隔: 5S
    if (lastDate && lastDate != nil) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastDate];
        if (interval < 5.0) {
            return;
        }
    }
    
    //gps坐标
    CLLocationCoordinate2D lastCoordinate = [newLocation coordinate];
    
    NSLog(@"gps success: 经度: %lf 纬度: %lf", lastCoordinate.longitude, lastCoordinate.latitude);
    
    //查询位置
    LocationEntity *locationEntity = [[LocationEntity alloc] init];
    locationEntity.longitude = [NSNumber numberWithFloat:lastCoordinate.longitude];
    locationEntity.latitude = [NSNumber numberWithFloat:lastCoordinate.latitude];
    
    if (!userHandler) userHandler = [[UserHandler alloc] init];
    [userHandler queryLocation:locationEntity success:^(NSArray *result){
        LocationEntity *location = [result firstObject];
        
        //获取位置
        if (location.address && [location.address length] > 0) {
            [homeView setData:@"address" value:location.address];
            [homeView renderData];
            
            lastDate = [NSDate date];
        }
    } failure:^(ErrorEntity *error){
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSString *errorMsg = ([error code] == kCLErrorDenied) ? @"定位失败" : @"定位失败";
    NSLog(@"gps error:%@", errorMsg);
    
    [homeView setData:@"address" value:errorMsg];
    [homeView renderData];
}

#pragma mark - Action
- (void)actionGps
{
    //初始化GPS
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10;
        locationManager.delegate = self;
        if (IS_IOS8_PLUS) {
            [locationManager requestWhenInUseAuthorization];
        }
    }
    
    [locationManager startUpdatingLocation];
    NSLog(@"start gps");
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
    intentionEntity.type = type;
    //@todo:gps坐标
    intentionEntity.location = @"0,0";
    
    NSLog(@"intention: %@", [intentionEntity toDictionary]);
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    CaseHandler *intentionHandler = [[CaseHandler alloc] init];
    [intentionHandler addIntention:intentionEntity success:^(NSArray *result){
        CaseEntity *intention = [result firstObject];
        
        NSLog(@"新增需求id: %@", intention.id);
        
        //跳转需求详情
        CaseViewController *viewController = [[CaseViewController alloc] init];
        viewController.caseId = intention.id;
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            [self pushViewController:viewController animated:YES];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

@end
