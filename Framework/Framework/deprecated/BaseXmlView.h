//
//  BaseXmlView.h
//  Framework
//
//  Created by wuyong on 16/1/19.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "BaseView.h"
#import "IView+Xml.h"

@class BaseXmlView;

typedef IView FIView;

//视图加载成功回调
typedef void (^XmlViewCallback)(BaseXmlView *view);

@interface BaseXmlView : BaseView

//设置xml文件路径，支持URL
+ (void)setXmlPath:(NSString *)xmlPath;

//设置xml文件后缀，默认html
+ (void)setXmlExt:(NSString *)xmlExt;

//设置补丁URL路径模板，优先加载补丁，补丁及时生效
//@todo：子类实现补丁，支持版本（url定义版本）或者支持单个设置，全局损耗性能
+ (void)setPatchPath:(NSString *)patchPath;

//加载某视图不执行回调
+ (BaseXmlView *)viewWithName:(NSString *)xmlName;

//加载某视图并执行回调，事件绑定需在页面加载完成后
+ (BaseXmlView *)viewWithName:(NSString *)xmlName callback:(XmlViewCallback)callback;

//视图名称，默认为视图名称去掉XmlView和View后的字符串，子类可重写
- (NSString *)xmlName;

//视图加载完成钩子，子类重写，事件绑定需在页面加载完成后
- (void)xmlViewLoaded;

//视图加载失败钩子，子类重写
- (void)xmlViewFailed;

//获取控制器
- (UIViewController *)viewController;

//设置控制器
- (void)setViewController:(UIViewController *)viewController;

//获取主元素
- (FIView *)body;

//获取子元素
- (FIView *)getElementById:(NSString *)id;

@end
