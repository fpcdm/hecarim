//
//  FWEntity.m
//  Framework
//
//  Created by 吴勇 on 16/2/14.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWEntity.h"
#import "MJExtension.h"
#import <objc/runtime.h>

@implementation FWEntity

+ (NSDictionary *)mj_objectClassInArray
{
    if (class_respondsToSelector([self class], @selector(classMap))) {
        return [self classMap];
    }
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

- (void)mergeDictionary:(NSDictionary *)dict
{
    [self mj_setKeyValues:dict];
}

- (NSDictionary *)toDictionary
{
    return [self mj_keyValues];
}

@end
