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
    [viewData setValue:value forKey:key];
}

- (id)getData:(NSString *)key
{
    return [viewData valueForKey:key];
}

//子类重写
- (void)renderData
{
    
}

@end
