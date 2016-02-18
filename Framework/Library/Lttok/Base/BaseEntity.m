//
//  BaseEntity.m
//  LttFramework
//
//  Created by wuyong on 15/6/2.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseEntity.h"
#import <objc/runtime.h>

@implementation BaseEntity

//深拷贝
- (id)copyWithZone:(NSZone *)zone
{
    BaseEntity *entity = [[[self class] allocWithZone:zone] init];
    
    //赋值为当前字典的值
    NSLog(@"to: %@", [self toDictionary]);
    [entity fromDictionary:[self toDictionary]];
    NSLog(@"from: %@", [entity toDictionary]);
    
    return entity;
}

//深拷贝
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self copyWithZone:zone];
}

//编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSDictionary *dict = [self toDictionary];
    for (NSString *key in dict) {
        id object = [dict objectForKey:key];
        if (object != nil && object != [NSNull null]) {
            [aCoder encodeObject:object forKey:key];
        }
    }
}

//解码
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        NSDictionary *dict = [self toDictionary];
        for (NSString *key in dict) {
            id object = [aDecoder decodeObjectForKey:key];
            if (object != nil && object != [NSNull null]) {
                //是否可设置值
                NSString *selectorStr = [NSString stringWithFormat:@"set%@%@:",[[key substringToIndex:1] uppercaseString], [key substringFromIndex:1]];
                SEL selector = NSSelectorFromString(selectorStr);
                if ([self respondsToSelector:selector]) {
                    [self setValue:object forKey:key];
                }
            }
        }
    }
    return self;
}

//从字典初始化
- (instancetype) initWithDictionary: (NSDictionary *) dict
{
    self = [super init];
    if (!self) return nil;
    
    [self fromDictionary:dict];
    
    return self;
}

//字典转换为实体对象
- (void) fromDictionary: (NSDictionary *) dict
{
    if (dict) {
        for (NSString *keyName in [dict allKeys]) {
            //构建出属性的set方法，第一个字母大写，其余字母不变，否则找不到方法，不能使用[keyName capitalizedString]
            NSString *destMethodName = [NSString stringWithFormat:@"set%@%@:",[[keyName substringToIndex:1] uppercaseString], [keyName substringFromIndex:1]];
            SEL destMethodSelector = NSSelectorFromString(destMethodName);
            
            //是否可设置值
            if ([self respondsToSelector:destMethodSelector]) {
                //还原属性值，NSNUll转换为nil
                id value = [dict objectForKey:keyName];
                if (value == [NSNull null]) {
                    value = nil;
                }
                [self setValue:value forKey:keyName];
            }
        }
    }
}

//对象转换为字典
- (NSDictionary *) toDictionary
{
    return [self toClassesDictionary:[self class]];
}

//类属性转化为字典（含父类）
- (NSDictionary *) toClassesDictionary: (Class) clazz
{
    NSDictionary *classDic = [self toClassDictionary:clazz];
    
    //父类为BaseEntity及其子类(isSubclassOfClass包含该Class)
    Class superClazz = [clazz superclass];
    if (![superClazz isSubclassOfClass:[BaseEntity class]]) {
        return classDic;
    }
    
    //获取父类属性
    NSDictionary *superDic = [self toClassesDictionary:superClazz];
    
    //合并字典
    NSMutableDictionary *mergeDic = [NSMutableDictionary dictionaryWithDictionary:classDic];
    [mergeDic addEntriesFromDictionary:superDic];
    return [NSDictionary dictionaryWithDictionary:mergeDic];
}

//单个类属性转化为字典
- (NSDictionary *) toClassDictionary: (Class) clazz
{
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        
        NSString *keyName = [NSString stringWithUTF8String:propertyName];
        SEL destMethodSelector = NSSelectorFromString(keyName);
        
        //是否可读取值
        if ([self respondsToSelector:destMethodSelector]) {
            //添加属性名
            [propertyArray addObject:keyName];
            
            //添加属性值，nil转换为NSNull
            id value = [self valueForKey:keyName];
            if (value == nil) {
                [valueArray addObject:[NSNull null]];
            } else {
                [valueArray addObject:value];
            }
        }
    }
    
    free(properties);
    
    NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    
    return returnDic;
}

@end
