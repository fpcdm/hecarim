//
//  CityView.h
//  LttMember
//
//  Created by wuyong on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppCollectionView.h"
#import "LocationEntity.h"

@protocol CityViewDelegate <NSObject>

- (void)actionGps;

- (void)actionCitySelected:(LocationEntity *)city;

@end

@interface CityView : AppCollectionView

@property (retain, nonatomic) id<CityViewDelegate> delegate;

@end
