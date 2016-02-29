//
//  AppView.h
//  LttMember
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseView.h"
#import "Config.h"
#import "AppUIUtil.h"
#import "AppExtension.h"

@interface BaseView (App)

//全局自定义，修改背景色
- (void) customView;

//根据控制器修正布局
- (void) layoutViewController:(UIViewController *)viewController;

@end

@interface AppView : BaseView

@end
