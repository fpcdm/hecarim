//
//  BaseXmlView.m
//  Framework
//
//  Created by wuyong on 16/1/19.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "BaseXmlView.h"
#import "FWCache.h"
#import "HttpUtil.h"

static NSString *xmlPath = nil;
static NSString *xmlExt = @"html";
static NSString *patchPath = nil;

#define XMLVIEW_CACHE_PREFIX @"XmlView."

#ifdef APP_DEBUG
#import "FWDebug.h"

@interface BaseXmlView () <FWDebugDelegate>

@end
#endif

@implementation BaseXmlView
{
    NSString *_xmlName;
    NSString *_xmlFileName;
    NSString *_xmlPath;
    BOOL _xmlIsUrl;
    XmlViewCallback _xmlCallback;
    
    IView *_xmlView;
}

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

+ (BaseXmlView *)viewWithName:(NSString *)xmlName
{
    return [self viewWithName:xmlName callback:nil];
}

+ (BaseXmlView *)viewWithName:(NSString *)xmlName callback:(XmlViewCallback)callback
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
    _xmlFileName = _xmlName;
    if (xmlExt && [[_xmlFileName lastPathComponent] rangeOfString:@"."].length < 1) {
        _xmlFileName = [NSString stringWithFormat:@"%@.%@", _xmlFileName, xmlExt];
    }
    
    _xmlPath = _xmlFileName;
    if (xmlPath) {
        _xmlPath = [HttpUtil joinPath:xmlPath path:_xmlPath];
    }
    _xmlIsUrl = [HttpUtil isUrl:_xmlPath];
    
#ifdef APP_DEBUG
    //注册调试代理
    [FWDebug sharedInstance].delegate = self;
    
    //监听URL改变
    if (_xmlIsUrl) {
        [[FWDebug sharedInstance] watchUrlStart:_xmlPath];
    }
    
    //关闭XML缓存
    [IView xmlCacheEnabled:NO];
#endif
    
    //检查补丁缓存是否存在
    NSString *patchXml = [self loadCache];
    //缓存存在
    if (patchXml != nil) {
        [self reloadXmlView:patchXml isFile:NO callback:^{
            //刷新缓存
            [self refreshCache:patchXml];
        }];
    //缓存不存在
    } else {
        [self reloadXmlView:nil isFile:NO callback:^{
            //监听补丁
            if (patchPath) {
                [self refreshCache:nil];
            }
        }];
    }
}

//重载视图，是否加载补丁
- (void)reloadXmlView:(NSString *)patchXml isFile:(BOOL)isFile callback:(void (^)())callback
{
    //补丁Xml
    if (patchXml) {
        //补丁文件
        if (isFile) {
            IView *view = [IView viewWithFile:patchXml];
            [self loadCallback:view];
        //补丁字符串
        } else {
            IView *view = [IView viewWithString:patchXml basePath:patchPath];
            [self loadCallback:view];
        }
        
        //执行回调
        if (callback) callback();
    //原始Xml
    } else {
        if (!_xmlIsUrl) {
            //自定义路径
            if (xmlPath) {
                IView *view = [IView viewWithFile:_xmlPath];
                [self loadCallback:view];
            //默认路径
            } else {
                IView *view = [IView viewWithName:_xmlPath];
                [self loadCallback:view];
            }
            
            //执行回调
            if (callback) callback();
            //远程文件
        } else {
            [IView viewWithUrl:_xmlPath callback:^(IView *view) {
                [self loadCallback:view];
                
                //执行回调
                if (callback) callback();
            }];
        }
    }
}

- (NSString *)loadCache
{
    NSString *xmlStr = nil;
    if (patchPath) {
        NSString *cacheKey = [NSString stringWithFormat:@"%@%@", XMLVIEW_CACHE_PREFIX, _xmlFileName];
        xmlStr = [[FWCache sharedInstance] get:cacheKey];
    }
    return xmlStr;
}

- (void)refreshCache:(NSString *)oldXml
{
    NSString *patchUrl = [HttpUtil joinPath:patchPath path:_xmlFileName];
    
    if ([HttpUtil isUrl:patchUrl]) {
        [HttpUtil get:patchUrl params:nil callback:^(NSData *data) {
            [self refreshCallback:data xml:oldXml];
        }];
    } else {
        NSData *data = [NSData dataWithContentsOfFile:patchUrl];
        [self refreshCallback:data xml:oldXml];
    }
}

- (void)refreshCallback:(NSData *)data xml:(NSString *)oldXml
{
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@", XMLVIEW_CACHE_PREFIX, _xmlFileName];
    if (data != nil) {
        NSString *newXml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!oldXml || ![oldXml isEqualToString:newXml]) {
            [[FWCache sharedInstance] set:cacheKey object:newXml];
            
            //动态刷新视图，注意事件绑定需在视图加载完成
            [self reloadXmlView:newXml isFile:NO callback:nil];
        }
    } else {
        [[FWCache sharedInstance] remove:cacheKey];
        
        //补丁移除时动态刷新视图，加载原视图
        if (oldXml) {
            [self reloadXmlView:nil isFile:NO callback:nil];
        }
    }
}

- (void)loadCallback:(IView *)view
{
    //移除之前的视图
    if (_xmlView) {
        [_xmlView removeFromSuperview];
        _xmlView = nil;
    }
    
    //加载成功
    if (view) {
        //添加视图
        _xmlView = view;
        [self addSubview:_xmlView];
        
        //回调函数
        [self xmlViewLoaded];
        if (_xmlCallback) {
            _xmlCallback(self);
        }
    //加载失败
    } else {
        //回调函数
        [self xmlViewFailed];
        if (_xmlCallback) {
            _xmlCallback(nil);
        }
    }
}

#ifdef APP_DEBUG
#if TARGET_IPHONE_SIMULATOR
//文件改变自动重新渲染
- (void)sourceFileChanged:(NSString *)filePath
{
    //本地文件名匹配
    if (!_xmlIsUrl && [_xmlFileName isEqualToString:[filePath lastPathComponent]]) {
        [self reloadXmlView:filePath isFile:YES callback:nil];
    }
}
#endif
#endif

#ifdef APP_DEBUG
//Url内容改变自动重新渲染
- (void)urlResponseChanged:(NSString *)url
{
    //远程URL和文件名匹配
    if (_xmlIsUrl && [_xmlPath isEqualToString:url]) {
        [self reloadXmlView:nil isFile:NO callback:nil];
    }
}
#endif

#ifdef APP_DEBUG
- (void)dealloc
{
    //解除调试代理
    [FWDebug sharedInstance].delegate = nil;
    
    //移除URL监听
    if (_xmlIsUrl) {
        [[FWDebug sharedInstance] watchUrlEnd:_xmlPath];
    }
}
#endif

- (void)xmlViewLoaded
{
    
}

- (void)xmlViewFailed
{
    
}

- (IView *)body
{
    return _xmlView;
}

- (IView *)getElementById:(NSString *)id
{
    return [_xmlView getElementById:id];
}

@end
