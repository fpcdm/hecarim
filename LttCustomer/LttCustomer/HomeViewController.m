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
#import "LocationUtil.h"

@interface HomeViewController () <HomeViewDelegate, LocationUtilDelegate>

@end

@implementation HomeViewController
{
    //控制接口间隔
    LocationUtil *locationUtil;
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

- (void)viewDidLoad
{
    isIndexNavBar = YES;
    isMenuEnabled = [self isLogin];
    hideBackButton = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"两条腿";
    
    //设置位置代理
    locationUtil = [LocationUtil sharedInstance];
    locationUtil.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [locationUtil startUpdate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [locationUtil stopUpdate];
}

#pragma mark - GPS
- (void) updateLocationSuccess:(CLLocationCoordinate2D)position
{
    //位置刷新请求间隔
    if (lastDate && lastDate != nil) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastDate];
        if (interval < USER_LOCATION_INTERVAL) {
            return;
        }
    }
    
    if (!helperHandler) helperHandler = [[HelperHandler alloc] init];
    
    //查询位置
    LocationEntity *locationEntity = [[LocationEntity alloc] init];
    locationEntity.longitude = [NSNumber numberWithFloat:position.longitude];
    locationEntity.latitude = [NSNumber numberWithFloat:position.latitude];
    
    [helperHandler queryLocation:locationEntity success:^(NSArray *result){
        LocationEntity *location = [result firstObject];
        
        //获取位置
        if (location.address && [location.address length] > 0) {
            [homeView setData:@"address" value:location.address];
        }
        
        //查询信使数量
        [helperHandler queryServiceNumber:locationEntity success:^(NSArray *result){
            LocationEntity *location = [result firstObject];
            
            //获取位置
            if (location.serviceNumber) {
                [homeView setData:@"count" value:location.serviceNumber];
                [homeView renderData];
                
                lastDate = [NSDate date];
            }
        } failure:^(ErrorEntity *error){
        }];
    } failure:^(ErrorEntity *error){
    }];
}

- (void)updateLocationError:(NSError *)error
{
    [homeView setData:@"address" value:@"定位失败"];
    [homeView setData:@"count" value:@-1];
    [homeView renderData];
}

#pragma mark - Action
- (void)actionGps
{
    [locationUtil restartUpdate];
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
    CLLocationCoordinate2D position = [locationUtil position];
    intentionEntity.location = [NSString stringWithFormat:@"%f,%f", position.longitude, position.latitude];
    
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
