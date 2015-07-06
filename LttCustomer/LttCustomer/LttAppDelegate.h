//
//  LttAppDelegate.h
//  LttCustomer
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LttNavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import "ErrorEntity.h"

@protocol LttLocationDelegate <NSObject>

@required
- (void) updateLocationSuccess:(CLLocationCoordinate2D) location;
- (void) updateLocationError: (ErrorEntity *) error;

@end

@interface LttAppDelegate : UIResponder <UIApplicationDelegate, REFrostedViewControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) CLLocationManager *locationManager;

@property (readonly, nonatomic) CLLocationCoordinate2D location;

@property (retain, nonatomic) id<LttLocationDelegate> locationDelegate;

@end

