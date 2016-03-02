//
//  FWEntity.h
//  Framework
//
//  Created by 吴勇 on 16/2/14.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWEntity : NSObject

//模型关联映射
+ (NSDictionary *)classMap;

//从字典创建
+ (instancetype)fromDictionary:(NSDictionary *)dict;

//从字典初始化
- (instancetype)initWithDictionary:(NSDictionary *)dict;

//合并字典
- (void)mergeDictionary:(NSDictionary *)dict;

//转为字典
- (NSDictionary *)toDictionary;

@end
