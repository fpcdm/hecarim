//
//  SettingView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol SettingViewDelegate <NSObject>

- (void)actionClear;

- (void)actionAbout;

@end

@interface SettingView : AppTableView

@property (retain, nonatomic) id<SettingViewDelegate> delegate;

@end
