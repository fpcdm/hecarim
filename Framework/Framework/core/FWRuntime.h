//
//  FWRuntime.h
//  Framework
//
//  Created by 吴勇 on 16/2/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWRuntime : NSObject

//获取类方法
+ (NSArray *)methodsOfClass:(Class)clazz;
+ (NSArray *)methodsOfClass:(Class)clazz withPrefix:(NSString *)prefix;

//获取类属性
+ (NSArray *)propertiesOfClass:(Class)clazz;
+ (NSArray *)propertiesOfClass:(Class)clazz withPrefix:(NSString *)prefix;

//获取对象属性
+ (NSDictionary *)propertiesOfObject:(id)obj;

@end
