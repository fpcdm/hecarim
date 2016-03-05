//
//  FWEntity.m
//  Framework
//
//  Created by 吴勇 on 16/2/14.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWEntity.h"
#import "MJExtension.h"

@implementation FWEntity

+ (NSDictionary *)mj_objectClassInArray
{
    return [self classMap];
}

+ (NSDictionary *)classMap
{
    return nil;
}

+ (instancetype)fromDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        [self mj_setKeyValues:dict];
    }
    return self;
}

//深拷贝
- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithDictionary:[self toDictionary]];
}

//深拷贝
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self copyWithZone:zone];
}

//编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mj_encode:aCoder];
}

//解码
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self mj_decode:aDecoder];
    }
    return self;
}

- (void)mergeDictionary:(NSDictionary *)dict
{
    [self mj_setKeyValues:dict];
}

- (NSDictionary *)toDictionary
{
    return [self mj_keyValues];
}

@end
