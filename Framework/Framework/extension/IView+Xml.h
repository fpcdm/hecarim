//
//  IView+Xml.h
//  Framework
//
//  Created by wuyong on 16/1/20.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "IView.h"

//视图初始化成功回调
typedef void (^IViewCallback)(IView *view);

//注意：为了以后重构简单，只能使用此分类的方法
@interface IView (Xml)

//开关缓存(Css缓存，页面缓存)
+ (void)xmlCacheEnabled:(BOOL)enabled;

//创建相关
+ (IView *)viewWithString:(NSString *)string;

+ (IView *)viewWithString:(NSString *)string basePath:(NSString *)basePath;

+ (IView *)viewWithFile:(NSString *)file;

+ (IView *)viewWithName:(NSString *)name;

+ (void)viewWithUrl:(NSString *)url callback:(IViewCallback)callback;

//样式相关
- (void)css:(NSString *)css;

- (void)setClass:(NSString *)clz;

- (void)addClass:(NSString *)clz;

- (void)removeClass:(NSString *)clz;

- (void)toggleClass:(NSString *)clz;

- (BOOL)hasClass:(NSString *)clz;

//可使用方法，主类实现
//- (void)show;

//- (void)hide;

//- (void)toggle;

//文档相关
- (IView *)getElementById:(NSString *)id;

@end
