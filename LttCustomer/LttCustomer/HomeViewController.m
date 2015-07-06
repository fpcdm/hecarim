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
#import "HelperHandler.h"
#import "LttAppDelegate.h"

@interface HomeViewController () <HomeViewDelegate, LttLocationDelegate>

@end

@implementation HomeViewController
{
    //控制接口间隔
    NSDate *lastDate;
    
    HomeView *homeView;
    HelperHandler *helperHandler;
}

- (void)loadView
{
    homeView = [[HomeView alloc] init];
    homeView.delegate = self;
    self.view = homeView;
}

- (LttAppDelegate *) appDelegate
{
    LttAppDelegate *appDelegate = (LttAppDelegate *) [UIApplication sharedApplication].delegate;
    return appDelegate;
}

- (void)viewDidLoad
{
    isIndexNavBar = YES;
    isMenuEnabled = [self isLogin];
    hideBackButton = YES;
    hasNavBack = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"两条腿";
    
    //初始化位置代理
    [self appDelegate].locationDelegate = self;
    
    //刷新位置
    [self actionGps];
    
    //todo: 服务人数
    [homeView setData:@"count" value:@12];
}

#pragma mark - GPS
- (void) updateLocationSuccess:(CLLocationCoordinate2D)location
{
    //请求间隔: 5S
    if (lastDate && lastDate != nil) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastDate];
        if (interval < 5.0) {
            return;
        }
    }
    
    NSLog(@"更新位置: 经度: %lf 纬度: %lf", location.longitude, location.latitude);
    
    //查询位置
    LocationEntity *locationEntity = [[LocationEntity alloc] init];
    locationEntity.longitude = [NSNumber numberWithFloat:location.longitude];
    locationEntity.latitude = [NSNumber numberWithFloat:location.latitude];
    
    if (!helperHandler) helperHandler = [[HelperHandler alloc] init];
    [helperHandler queryLocation:locationEntity success:^(NSArray *result){
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

- (void)updateLocationError:(ErrorEntity *)error
{
    [homeView setData:@"address" value:@"定位失败"];
    [homeView renderData];
}

#pragma mark - Action
- (void)actionGps
{
    CLLocationManager *locationManager = [self appDelegate].locationManager;
    
    [locationManager stopUpdatingLocation];
    [locationManager startUpdatingLocation];
    NSLog(@"refresh gps");
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
    
    //获取gps坐标
    CLLocationCoordinate2D location = [self appDelegate].location;
    intentionEntity.location = [NSString stringWithFormat:@"%f,%f", location.longitude, location.latitude];
    
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
