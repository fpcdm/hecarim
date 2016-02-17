//
//  PaginationEntity.m
//  Framework
//
//  Created by wuyong on 16/1/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "PaginationEntity.h"

@implementation PaginationEntity

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    self.page = @1;
    self.pageSize = @10;
    self.total = @0;
    
    return self;
}

- (NSUInteger)offset
{
    NSInteger offset = (self.page.integerValue - 1) * self.pageSize.integerValue;
    return offset >= 0 ? offset : 0;
}

- (BOOL)hasMore
{
    BOOL hasMore = self.offset + self.pageSize.integerValue < self.total.integerValue;
    return hasMore;
}

@end
