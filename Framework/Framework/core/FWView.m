//
//  FWView.m
//  Framework
//
//  Created by 吴勇 on 16/2/14.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWView.h"

@implementation FWView
{
    NSMutableDictionary *viewData;
}

- (void)assign:(NSString *)key value:(id)value
{
    //参数检查
    if (value == nil) return;
    
    //初始化参数
    if (!viewData) {
        viewData = [[NSMutableDictionary alloc] init];
    }
    
    //赋值
    [viewData setObject:value forKey:key];
}

- (id)fetch:(NSString *)key
{
    //未赋值
    if (!viewData) return nil;
    
    id value = [viewData objectForKey:key];
    return value;
}

- (void)display
{
    //子类重写
}

- (void)render:(NSString *)key
{
    //子类重写
}

@end
