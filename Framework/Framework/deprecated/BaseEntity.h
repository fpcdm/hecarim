//
//  BaseEntity.h
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

//注意：BaseEntity子类不要用简单数据类型，如BOOL等，否则无法转字典，建议使用可以转化为NSDictionary的类型
@interface BaseEntity : NSObject <NSCopying, NSMutableCopying, NSCoding>

//从字典初始化
- (instancetype) initWithDictionary: (NSDictionary *) dict;

//字典转换为实体对象
- (void) fromDictionary: (NSDictionary *) dict;

//对象转换为字典
- (NSDictionary *) toDictionary;

@end
