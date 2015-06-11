//
//  BaseEntity.h
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEntity : NSObject

//字典转换为实体对象
- (void) fromDictionary: (NSDictionary *) dict;

//对象转换为字典
- (NSDictionary *) toDictionary;

@end
