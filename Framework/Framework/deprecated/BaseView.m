//
//  BaseView.m
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //自定义视图钩子，子类可以实现(不会影响别的子类)，也可以利用类分类实现(会影响别的子类)
    if ([self respondsToSelector:@selector(customView)]) {
        [self performSelector:@selector(customView)];
    }
    
    return self;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [self init];
    
    if (data) {
        for (NSString *key in data) {
            [self assign:key value:[data objectForKey:key]];
        }
    }
    
    return self;
}

- (id)initWithData:(NSDictionary *)data frame:(CGRect)frame
{
    self = [self initWithData:data];
    
    self.frame = frame;
    
    return self;
}

@end

//已废弃
@implementation BaseView (Deprecated)

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

@end
