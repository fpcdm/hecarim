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
    self = [super init];
    if (!self) return nil;
    
    if (viewData == nil) {
        viewData = [[NSMutableDictionary alloc] init];
    }
    
    //自定义视图钩子，子类可以实现(不会影响别的子类)，也可以利用类分类实现(会影响别的子类)
    if ([self respondsToSelector:@selector(customView)]) {
        [self performSelector:@selector(customView)];
    }
    
    return self;
}

- (id)initWithData:(NSDictionary *)data
{
    viewData = [[NSMutableDictionary alloc] initWithDictionary:data];
    
    return [self init];
}

- (id)initWithData:(NSDictionary *)data frame:(CGRect)frame
{
    self = [self initWithData:data];
    
    self.frame = frame;
    
    return self;
}

- (void)setData: (NSString *)key value:(id)value
{
    //自动替换nil为NSNull
    if (value == nil) {
        value = [NSNull null];
    }
    [viewData setObject:value forKey:key];
}

- (id)getData:(NSString *)key
{
    //自动还原NSNull为nil
    id value = [viewData objectForKey:key];
    if (value == [NSNull null]) {
        value = nil;
    }
    return value;
}

//子类重写
- (void)renderData
{
    
}

@end
