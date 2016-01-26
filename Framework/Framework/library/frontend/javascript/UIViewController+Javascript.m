//
//  UIViewController+Javascript.m
//  Framework
//
//  Created by 吴勇 on 16/1/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UIViewController+Javascript.h"
#import "NSObject+Framework.h"

@implementation UIViewController (Javascript)

- (void)setURL:(FWUrl *)URL
{
    [self willChangeValueForKey:@"URL"]; //KVO
    [self setAssociatedObject:URL forKey:"URL"];
    [self didChangeValueForKey:@"URL"];  //KVO
}

- (FWUrl *)URL
{
    //获取设置的值
    FWUrl *URL = [self getAssociatedObjectForKey:"URL"];
    
    //获取默认值，不包含默认参数，需要参数请子类重写
    if (!URL) {
        URL = [FWUrl urlWithPath:NSStringFromClass([self class]) query:nil fragment:nil];
    }
    
    //返回URL
    return URL;
}

@end
