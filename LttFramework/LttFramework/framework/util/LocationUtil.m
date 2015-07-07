//
//  LocationUtil.m
//  LttFramework
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "LocationUtil.h"
#import "FrameworkConfig.h"

static LocationUtil *sharedInstance = nil;

@interface LocationUtil () <CLLocationManagerDelegate>

@end

@implementation LocationUtil
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D position;
}

+ (LocationUtil *) sharedInstance
{
    //多线程唯一
    @synchronized(self){
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self) {
        //初始化坐标为0
        position = CLLocationCoordinate2DMake(0, 0);
        
        //初始化GPS
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10;
        locationManager.delegate = self;
        if (IS_IOS8_PLUS) {
            [locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

- (CLLocationManager *) locationManager
{
    return locationManager;
}

- (CLLocationCoordinate2D) position
{
    return position;
}

- (void) startUpdate
{
    [locationManager startUpdatingLocation];
    NSLog(@"start gps");
}

- (void) stopUpdate
{
    [locationManager stopUpdatingLocation];
    NSLog(@"stop gps");
}

- (void) restartUpdate
{
    [locationManager stopUpdatingLocation];
    [locationManager startUpdatingLocation];
    NSLog(@"restart gps");
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    //更新位置
    position = [newLocation coordinate];
    
    NSLog(@"gps success: 经度: %lf 纬度: %lf", position.longitude, position.latitude);
    
    //调用代理
    if (self.delegate) {
        [self.delegate updateLocationSuccess:position];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSString *errorMsg = ([error code] == kCLErrorDenied) ? @"访问被拒绝" : @"获取地理位置失败";
    NSLog(@"gps error:%@", errorMsg);
    
    //调用代理
    if (self.delegate) {
        [self.delegate updateLocationError:error];
    }
}

@end
