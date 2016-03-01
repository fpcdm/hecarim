//
//  FWXmlView.h
//  Framework
//
//  Created by wuyong on 16/2/17.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWView.h"
#import "IView.h"

@interface FWXmlConfig : NSObject

//设置xml文件路径，支持URL
+ (void)setXmlPath:(NSString *)xmlPath;

//设置xml文件后缀，默认html
+ (void)setXmlExt:(NSString *)xmlExt;

//设置补丁路径模板，优先加载补丁，建议根据版本使用补丁zip包，下载到本地解压到补丁路径
+ (void)setPatchPath:(NSString *)patchPath;

@end

@interface FWXmlView : FWView

//加载某视图不执行回调，用于本地文件
+ (FWXmlView *)viewWithName:(NSString *)xmlName;

//加载某视图并执行回调，事件绑定需在页面加载完成后，用于本地和远程文件
+ (FWXmlView *)viewWithName:(NSString *)xmlName callback:(void (^)(FWXmlView *view))callback;

//视图名称，默认为视图名称去掉XmlView和View后的字符串，子类可重写
- (NSString *)xmlName;

//视图加载完成钩子，子类重写，事件绑定需在页面加载完成后
- (void)xmlViewLoaded;

//视图加载失败钩子，子类重写
- (void)xmlViewFailed;

//获取文档主元素
- (FIView *)document;

//获取子元素
- (FIView *)getElementById:(NSString *)id;

@end
