//
//  FWTheme.h
//  Framework
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FWTheme : NSObject

@singleton(FWTheme)

//设置主题文件名称，默认ThemePlist.plist
- (void)setThemeFile:(NSString *)file;

//自定义单个主题设置
- (void)defineTheme:(NSString *)name definition:(NSDictionary *)definition;

//设置所用的主题名称，默认default
- (void)setTheme:(NSString *)name;

//获取当前主题的所有定义
- (NSDictionary *)definition;

//获取主题的某个颜色
- (UIColor *)color:(NSString *)key;

@end
