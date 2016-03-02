//
//  FWApplication.h
//  Framework
//
//  Created by wuyong on 16/3/1.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWApplication : NSObject

//单例对象
@singleton(FWApplication)

//只读属性
@prop_readonly(id<UIApplicationDelegate>, delegate)
@prop_readonly(UIWindow *, window)

//导航根属性：最内层
@prop_readonly(UIViewController *, rootViewController)

//导航活动属性：最外层
@prop_readonly(UITabBarController *, tabBarController)
@prop_readonly(UINavigationController *, navigationController)
@prop_readonly(UIViewController *, viewController)

@end
