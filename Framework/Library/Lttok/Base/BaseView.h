//
//  BaseView.h
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWView.h"

@interface BaseView : FWView

- (id)initWithData:(NSDictionary *)data;

- (id)initWithData:(NSDictionary *)data frame:(CGRect)frame;

@end

//已废弃
@interface BaseView (Deprecated)

//设置数据，已废弃，请使用assign
- (void)setData:(NSString *)key value:(id)value DEPRECATED_MESSAGE("Please use assign:value:");

//获取数据，已废弃，请使用fetch
- (id)getData:(NSString *)key DEPRECATED_MESSAGE("Please use fetch:");

//渲染所有数据，子类重写，需手工调用，已废弃，请使用display
- (void)renderData DEPRECATED_MESSAGE("Please use display");

@end
