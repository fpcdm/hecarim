//
//  DynamicEntity.h
//  Framework
//
//  Created by wuyong on 16/1/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWEntity.h"

@interface DynamicEntity : FWEntity

@prop_strong(NSDictionary *, data)

- (id)get:(NSString *)key;

- (BOOL)has:(NSString *)key;

- (void)set:(NSString *)key object:(id)object;

- (void)remove:(NSString *)key;

- (void)clear;

@end
