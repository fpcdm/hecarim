//
//  ThemeUtil.h
//  LttMember
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeUtil : NSObject

//设置主题文件名称，默认ThemePlist.plist
+ (void)setThemeFile:(NSString *)file;

//设置所用的主题名称，默认Default
+ (void)setTheme:(NSString *)name;

//获取当前主题的所有定义
+ (NSDictionary *)definitions;

//获取主题的某个颜色
+ (UIColor *)color:(NSString *)key;

@end
