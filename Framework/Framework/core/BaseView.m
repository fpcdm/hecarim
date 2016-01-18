//
//  BaseView.m
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView
{
    NSMutableDictionary *viewData;
}

- (id)init
{
    return [self initWithData:nil];
}

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (!self) return nil;
    
    viewData = [NSMutableDictionary dictionaryWithDictionary:data];
    
    //自定义视图钩子，子类可以实现(不会影响别的子类)，也可以利用类分类实现(会影响别的子类)
    if ([self respondsToSelector:@selector(customView)]) {
        [self performSelector:@selector(customView)];
    }
    
    return self;
}

- (id)initWithData:(NSDictionary *)data frame:(CGRect)frame
{
    self = [self initWithData:data];
    
    self.frame = frame;
    
    return self;
}

- (void)setData: (NSString *)key value:(id)value
{
    [self assign:key value:value];
}

- (id)getData:(NSString *)key
{
    return [self fetch:key];
}

- (void)renderData
{
    [self display];
}

- (void)assign:(NSDictionary *)data
{
    [viewData addEntriesFromDictionary:data];
}

- (void)assign:(NSString *)key value:(id)value
{
    //自动替换nil为NSNull
    if (value == nil) {
        value = [NSNull null];
    }
    [viewData setObject:value forKey:key];
}

- (id)fetch:(NSString *)key
{
    //自动还原NSNull为nil
    id value = [viewData objectForKey:key];
    if (value == [NSNull null]) {
        value = nil;
    }
    return value;
}

- (void)display:(NSDictionary *)data
{
    [self assign:data];
    [self display];
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
