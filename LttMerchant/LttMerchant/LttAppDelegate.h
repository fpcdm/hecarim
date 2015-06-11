//
//  LttAppDelegate.h
//  LttMerchant
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Config.h"

@interface LttAppDelegate : UIResponder <UIApplicationDelegate, REFrostedViewControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) CLLocationManager *locationManager;

@property(readonly, nonatomic) CLLocationCoordinate2D lastCoordinate;

@end

