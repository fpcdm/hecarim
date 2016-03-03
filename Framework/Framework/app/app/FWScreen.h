//
//  FWScreen.h
//  Framework
//
//  Created by 吴勇 on 16/3/2.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWScreen : NSObject

@singleton(FWScreen)

//屏幕边界
@prop_readonly(CGRect, bounds)
@prop_readonly(CGFloat, width)
@prop_readonly(CGFloat, height)

//当前有效边界(自动扣除状态栏，导航栏，TabBar)
@prop_readonly(CGRect, availBounds)
@prop_readonly(CGFloat, availWidth)
@prop_readonly(CGFloat, availHeight)

//组件高度
@prop_readonly(CGFloat, statusBarHeight)
@prop_readonly(CGFloat, navigationBarHeight)
@prop_readonly(CGFloat, tabBarHeight)

//组件有效高度
@prop_readonly(CGFloat, availStatusBarHeight)
@prop_readonly(CGFloat, availNavigationBarHeight)
@prop_readonly(CGFloat, availTabBarHeight)

//组件是否显示
@prop_readonly(BOOL, statusBarHidden)
@prop_readonly(BOOL, navigationBarHidden)
@prop_readonly(BOOL, tabBarHidden)

@end
