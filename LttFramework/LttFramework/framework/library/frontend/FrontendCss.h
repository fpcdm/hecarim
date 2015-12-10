//
//  FrontendStyle.h
//  LttMember
//
//  Created by wuyong on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FrontendCss : NSObject

@property (retain, nonatomic, readonly) UIView *view;

- (id)initWithView:(UIView *)view;

//定义全局样式
+ (void)defineGlobalClass:(NSString *)name styles:(NSDictionary *)styles;

//返回全局样式
+ (NSDictionary *)globalClassForName:(NSString *)name;

//清除全局定义
+ (void)clearGlobalDefines;

//定义局部样式
- (void)defineClass:(NSString *)name styles:(NSDictionary *)styles;

//获取局部样式（含全局）
- (NSDictionary *)classForName:(NSString *)name;

//清理局部定义
- (void)clearDefines;

//设置样式
- (void)setClasses:(NSArray *)names;

//添加样式
- (void)addClass:(NSString *)name;

//是否含有样式
- (BOOL)hasClass:(NSString *)name;

//移除样式
- (void)removeClass:(NSString *)name;

//切换样式
- (void)toggleClass:(NSString *)name;

//获取单个样式
- (NSString *)css:(NSString *)name;

//设置单个样式
- (void)setCss:(NSString *)name value:(NSString *)value;

//批量设施样式
- (void)setCss:(NSDictionary *)values;

@end
