//
//  LocationUtil.h
//  LttFramework
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationUtilDelegate <NSObject>

@required
- (void) updateLocationSuccess: (CLLocationCoordinate2D) position;
- (void) updateLocationError: (NSError *) error;

@end

@interface LocationUtil : NSObject

//计算两点距离，单位:米
+ (double) getDistance:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to;

+ (LocationUtil *) sharedInstance;

- (CLLocationManager *) locationManager;

- (CLLocationCoordinate2D) position;

//开始更新位置
- (void) startUpdate;

//停止更新位置
- (void) stopUpdate;

//刷新位置
- (void) restartUpdate;

@property (retain, nonatomic) id<LocationUtilDelegate> delegate;

@end
