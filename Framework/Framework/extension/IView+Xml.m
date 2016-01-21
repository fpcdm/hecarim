//
//  IView+Xml.m
//  Framework
//
//  Created by wuyong on 16/1/20.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "IView+Xml.h"
#import "IKitUtil.h"
#import "IView.h"
#import "IResourceMananger.h"
#import "IViewLoader.h"

@implementation IView (Xml)

+ (void)xmlCacheEnabled:(BOOL)enabled
{
    [IResourceMananger sharedMananger].enableCssCache = enabled;
}

+ (IView *)viewWithString:(NSString *)string
{
    return [IView viewFromXml:string];
}

+ (IView *)viewWithString:(NSString *)string basePath:(NSString *)basePath
{
    return [IViewLoader viewFromXml:string basePath:basePath];
}

+ (IView *)viewWithFile:(NSString *)file
{
    return [IView viewWithContentsOfFile:file];
}

+ (IView *)viewWithName:(NSString *)name
{
    return [IView namedView:name];
}

+ (void)viewWithUrl:(NSString *)url callback:(IViewCallback)callback
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [IViewLoader loadUrl:url callback:^(IView *view) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (callback) {
            callback(view);
        }
    }];
}

- (void)css:(NSString *)css
{
    [self.style set:css];
}

- (void)setClass:(NSString *)clz
{
    [self.style setClass:clz];
}

- (void)addClass:(NSString *)clz
{
    [self.style addClass:clz];
}

- (void)removeClass:(NSString *)clz
{
    [self.style removeClass:clz];
}

- (void)toggleClass:(NSString *)clz
{
    if ([self.style hasClass:clz]) {
        [self.style removeClass:clz];
    } else {
        [self.style addClass:clz];
    }
}

- (BOOL)hasClass:(NSString *)clz
{
    return [self.style hasClass:clz];
}

- (IView *)getElementById:(NSString *)id
{
    return [self getViewById:id];
}

@end
