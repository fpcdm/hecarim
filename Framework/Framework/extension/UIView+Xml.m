//
//  UIView+Xml.m
//  Framework
//
//  Created by wuyong on 16/1/20.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UIView+Xml.h"
#import "IKitUtil.h"
#import "IView.h"
#import "IResourceMananger.h"
#import "IViewLoader.h"

@implementation UIView (Xml)

+ (void)xmlCacheEnabled:(BOOL)enabled
{
    [IResourceMananger sharedMananger].enableCssCache = enabled;
}

+ (UIView *)viewWithString:(NSString *)string
{
    return [IView viewFromXml:string];
}

+ (UIView *)viewWithString:(NSString *)string basePath:(NSString *)basePath
{
    return [IViewLoader viewFromXml:string basePath:basePath];
}

+ (UIView *)viewWithFile:(NSString *)file
{
    return [IView viewWithContentsOfFile:file];
}

+ (UIView *)viewWithName:(NSString *)name
{
    return [IView namedView:name];
}

+ (void)viewWithUrl:(NSString *)url callback:(ViewXmlCallback)callback
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [IViewLoader loadUrl:url callback:^(IView *view) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (callback) {
            callback(view);
        }
    }];
}

+ (NSString *)getRootPath:(NSString *)path
{
    return [IKitUtil getRootPath:path];
}

+ (NSString *)getBasePath:(NSString *)path
{
    return [IKitUtil getBasePath:path];
}

+ (NSString *)joinPath:(NSString *)basePath path:(NSString *)path
{
    return [IKitUtil buildPath:basePath src:path];
}

@end
