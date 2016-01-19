//
//  BaseXmlView.m
//  Framework
//
//  Created by wuyong on 16/1/19.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "BaseXmlView.h"
#import "IKitUtil.h"
#import "IView.h"
#import "IResourceMananger.h"
#import "IViewLoader.h"

static NSString *xmlPath = nil;
static NSString *xmlExt = @"html";
static NSString *patchPath = nil;

#ifdef APP_DEBUG
#if TARGET_IPHONE_SIMULATOR
#import "DebugUtil.h"

@interface BaseXmlView () <DebugUtilDelegate>

@end
#endif
#endif

@implementation BaseXmlView
{
    NSString *_xmlName;
    NSString *_xmlFile;
    XmlViewCallback _xmlCallback;
}

@def_prop_readonly(IView *, xmlView)

+ (void)setXmlPath:(NSString *)_xmlPath
{
    xmlPath = _xmlPath;
}

+ (void)setXmlExt:(NSString *)_xmlExt
{
    xmlExt = _xmlExt;
}

+ (void)setPatchPath:(NSString *)_patchPath
{
    patchPath = _patchPath;
}

+ (BaseXmlView *)loadXmlView:(NSString *)xmlName callback:(XmlViewCallback)callback
{
    BaseXmlView *xmlView = [[BaseXmlView alloc] initWithXmlName:xmlName callback:callback];
    return xmlView;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _xmlName = [self xmlName];
    _xmlCallback = nil;
    
    [self loadXmlView];
    
    return self;
}

- (instancetype)initWithXmlName:(NSString *)xmlName callback:(XmlViewCallback)callback
{
    self = [super init];
    if (!self) return nil;
    
    _xmlName = xmlName;
    _xmlCallback = callback;
    
    [self loadXmlView];
    
    return self;
}

- (NSString *)xmlName
{
    if (_xmlName) {
        return _xmlName;
    } else {
        NSString *xmlName = NSStringFromClass([self class]);
        xmlName = [xmlName stringByReplacingOccurrencesOfString:@"XmlView" withString:@""];
        xmlName = [xmlName stringByReplacingOccurrencesOfString:@"View" withString:@""];
        _xmlName = xmlName;
        return _xmlName;
    }
}

- (void)loadXmlView
{
    _xmlFile = xmlExt ? [NSString stringWithFormat:@"%@.%@", _xmlName, xmlExt] : _xmlName;
    if (xmlPath) {
        _xmlFile = [IKitUtil buildPath:xmlPath src:_xmlFile];
    }
    
#ifdef APP_DEBUG
#if TARGET_IPHONE_SIMULATOR
    //注册调试代理
    [DebugUtil sharedInstance].delegate = self;
#endif
#endif
    
    //本地文件
    if (![IKitUtil isHttpUrl:_xmlFile]) {
        IView *view = [IView namedView:_xmlFile];
        [self loadCallback:view];
    //远程文件
    } else {
        [IViewLoader loadUrl:_xmlFile callback:^(IView *view) {
            [self loadCallback:view];
        }];
    }
}

- (void)loadCallback:(IView *)view
{
    //移除之前的视图
    if (_xmlView) {
        [_xmlView removeFromSuperview];
        _xmlView = nil;
    }
    
    //添加视图
    _xmlView = view;
    [self addSubview:_xmlView];
    
    //加载成功
    [self xmlViewLoaded];
    
    //回调函数
    if (_xmlCallback) {
        _xmlCallback(self);
    }
}

#ifdef APP_DEBUG
#if TARGET_IPHONE_SIMULATOR
//文件改变自动重写渲染
- (void)sourceFileChanged:(NSString *)filePath
{
    //本地文件
    if (![IKitUtil isHttpUrl:_xmlFile]) {
        IView *view = [IView namedView:_xmlFile];
        [self loadCallback:view];
    }
}
#endif
#endif

- (void)xmlViewLoaded
{
    
}

- (void)xmlViewFailed
{
    
}

@end
