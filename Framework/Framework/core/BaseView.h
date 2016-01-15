//
//  BaseView.h
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameworkConfig.h"
#import "Masonry.h"

@interface BaseView : UIView

- (id)initWithData:(NSDictionary *)data;

- (id)initWithData:(NSDictionary *)data frame:(CGRect)frame;

//设置数据，init之后调用
- (void)setData:(NSString *)key value:(id)value;

//获取数据，init之后调用
- (id)getData:(NSString *)key;

//渲染数据，init之后调用
- (void)renderData;

@end
