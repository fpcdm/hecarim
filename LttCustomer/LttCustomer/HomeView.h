//
//  HomeView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol HomeViewDelegate <NSObject>

@end

@interface HomeView : AppView

@property (retain, nonatomic) id<HomeViewDelegate> delegate;

@end
