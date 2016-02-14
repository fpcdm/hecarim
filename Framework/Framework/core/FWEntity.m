//
//  FWEntity.m
//  Framework
//
//  Created by 吴勇 on 16/2/14.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWEntity.h"

@implementation FWEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    return [self initWithDictionary:dict error:nil];
}

- (void)mergeFromDictionary:(NSDictionary *)dict
{
    [self mergeFromDictionary:dict useKeyMapping:YES error:nil];
}

@end
