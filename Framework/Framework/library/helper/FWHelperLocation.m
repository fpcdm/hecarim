//
//  FWHelperLocation.m
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHelperLocation.h"

@interface FWHelperLocation () <CLLocationManagerDelegate>

@end

@implementation FWHelperLocation
{
    CLLocationManager *locationManager;
    CLLocation *location;
}

@def_notification(UpdateLocationSuccess)
@def_notification(UpdateLocationFailed)

@def_singleton(FWHelperLocation)

+ (CLLocationDistance)getDistance:(CLLocation *)from to:(CLLocation *)to
{
    //比[from distanceFromLocation:to]精确
    double radLat1 = from.coordinate.latitude * M_PI / 180.0;
    double radLat2 = to.coordinate.latitude * M_PI / 180.0;
    double a = radLat1 - radLat2;
    double b = from.coordinate.longitude * M_PI / 180.0 - to.coordinate.longitude * M_PI / 180.0;
    
    double s = 2 * sin(sqrt(pow(sin(a / 2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    s = s * 6378137;
    s = round(s * 100) / 100;
    return s;
}

- (id) init
{
    self = [super init];
    if (self) {
        //初始化GPS
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10;
        locationManager.delegate = self;
        if (IS_IOS8P) {
            [locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

- (CLLocationManager *) locationManager
{
    return locationManager;
}

- (CLLocation *)location
{
    return location;
}

- (void) startNotifier
{
    [locationManager startUpdatingLocation];
}

- (void) stopNotifier
{
    [locationManager stopUpdatingLocation];
}

- (void) restartNotifier
{
    [locationManager stopUpdatingLocation];
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    //更新位置
    location = newLocation;
    
    //发送通知
    [self postNotification:self.UpdateLocationSuccess withObject:location];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    //不清空最新位置，error.code为kCLErrorDenied时原因为访问被拒绝
    [FWLog debug:@"UpdateLocationFailed: %@", error];
    
    //发送通知
    [self postNotification:self.UpdateLocationFailed withObject:error];
}

@end
