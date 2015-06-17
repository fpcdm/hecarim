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
    [entity fromDictionary:[self toDictionary]];
    
    return entity;
}

//深拷贝
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self copyWithZone:zone];
}

//字典转换为实体对象
- (void) fromDictionary: (NSDictionary *) dict
{
    if (dict) {
        for (NSString *keyName in [dict allKeys]) {
            //构建出属性的set方法
            NSString *destMethodName = [NSString stringWithFormat:@"set%@:",[keyName capitalizedString]]; //capitalizedString返回每个单词首字母大写的字符串（每个单词的其余字母转换为小写）
            SEL destMethodSelector = NSSelectorFromString(destMethodName);
            
            if ([self respondsToSelector:destMethodSelector]) {
                //还原属性值，NSNUll转换为nil
                id value = [dict objectForKey:keyName];
                if (value == [NSNull null]) {
                    value = nil;
                }
                [self performSelector:destMethodSelector withObject:value];
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
        
        SEL destMethodSelector = NSSelectorFromString([NSString stringWithUTF8String:propertyName]);
        
        if ([self respondsToSelector:destMethodSelector]) {
            //添加属性名
            [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
            
            //添加属性值，nil转换为NSNull
            id value = [self performSelector:destMethodSelector];
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
