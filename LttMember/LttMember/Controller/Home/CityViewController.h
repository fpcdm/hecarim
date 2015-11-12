//
//  CityViewController.h
//  LttMember
//
//  Created by wuyong on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"
#import "LocationEntity.h"

@interface CityViewController : AppViewController

//定位地址
@property (retain, nonatomic) LocationEntity *gpsLocation;

//刷新视图
- (void) reloadView;

@end
