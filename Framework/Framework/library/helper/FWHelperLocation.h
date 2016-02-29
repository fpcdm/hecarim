//
//  FWHelperLocation.h
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FWHelperLocation : NSObject

@notification(UpdateLocationSuccess)
@notification(UpdateLocationFailed)

@singleton(FWHelperLocation)

//计算两点距离，单位:米
+ (CLLocationDistance) getDistance:(CLLocation *)from to:(CLLocation *)to;

//获取原始CLLocationManager
- (CLLocationManager *) locationManager;

//获取当前location
- (CLLocation *)location;

//开始更新位置
- (void) startNotifier;

//停止更新位置
- (void) stopNotifier;

//重新更新位置
- (void) restartNotifier;

@end
