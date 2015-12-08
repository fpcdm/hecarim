//
//  UIView+Frontend.m
//  LttMember
//
//  Created by wuyong on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "UIView+Frontend.h"
#import <objc/runtime.h>

@implementation UIView (Frontend)

#pragma mark - dom
static const char UIViewFrontendDomKey = '\0';
- (FrontendDom *)dom
{
    FrontendDom *dom = objc_getAssociatedObject(self, &UIViewFrontendDomKey);
    
    //设置默认值
    if (!dom) {
        dom = [[FrontendDom alloc] initWithView:self];
        [self willChangeValueForKey:@"dom"];
        objc_setAssociatedObject(self, &UIViewFrontendDomKey, dom, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"dom"];
    }
    
    return dom;
}

#pragma mark - css
static const char UIViewFrontendCssKey = '\0';
- (FrontendCss *)css
{
    FrontendCss *css = objc_getAssociatedObject(self, &UIViewFrontendCssKey);
    
    //设置默认值
    if (!css) {
        css = [[FrontendCss alloc] initWithView:self];
        [self willChangeValueForKey:@"css"];
        objc_setAssociatedObject(self, &UIViewFrontendCssKey, css, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"css"];
    }
    
    return css;
}

@end
