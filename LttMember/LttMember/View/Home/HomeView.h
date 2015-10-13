//
//  HomeView.h
//  LttMember
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol HomeViewDelegate <NSObject>

@required
- (void)actionCase: (NSNumber *) type;
- (void)actionGps;
- (void)actionReload;

@end

@interface HomeView : AppView

@property (retain, nonatomic) id<HomeViewDelegate> delegate;

@end
