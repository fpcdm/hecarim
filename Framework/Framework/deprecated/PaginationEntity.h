//
//  PaginationEntity.h
//  Framework
//
//  Created by wuyong on 16/1/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "BaseEntity.h"

@interface PaginationEntity : BaseEntity

@prop_strong(NSNumber *, page)
@prop_strong(NSNumber *, pageSize)
@prop_strong(NSNumber *, total)

- (NSUInteger)offset;
- (BOOL)hasMore;

@end
