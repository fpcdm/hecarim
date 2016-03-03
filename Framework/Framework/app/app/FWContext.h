//
//  FWContext.h
//  Framework
//
//  Created by wuyong on 16/3/1.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWContext : NSObject

//单例对象
@singleton(FWContext)

//导航根属性：最内层
@prop_readonly(UIWindow *, window)
@prop_readonly(UIViewController *, rootViewController)

//导航活动属性：最外层
@prop_readonly(UITabBarController *, tabBarController)
@prop_readonly(UINavigationController *, navigationController)
@prop_readonly(UIViewController *, viewController)

@end
