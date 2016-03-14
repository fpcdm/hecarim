//
//  FWRuntime.h
//  Framework
//
//  Created by 吴勇 on 16/2/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWRuntime : NSObject

//获取子类列表，不含类本身
+ (NSArray *)subclassesOfClass:(Class)clazz;
+ (NSArray *)subclassesOfClass:(Class)clazz withPrefix:(NSString *)prefix;

//获取类方法
+ (NSArray *)methodsOfClass:(Class)clazz;
+ (NSArray *)methodsOfClass:(Class)clazz withPrefix:(NSString *)prefix;

//获取类属性
+ (NSArray *)propertiesOfClass:(Class)clazz;
+ (NSArray *)propertiesOfClass:(Class)clazz mutable:(BOOL)mutable;

//获取对象属性
+ (NSDictionary *)propertiesOfObject:(id)obj;

//拷贝对象
+ (id)copyObject:(id)obj;
+ (id)copyObject:(id)obj withZone:(NSZone *)zone;

//对象编码解码
+ (void)encodeObject:(id)obj withCoder:(NSCoder *)aCoder;
+ (void)decodeObject:(id)obj withCoder:(NSCoder *)aDecoder;

@end
