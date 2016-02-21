//
//  FWSignal.h
//  Framework
//
//  Created by 吴勇 on 16/2/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWSignal : NSObject

+ (FWSignal *)signal;

@prop_assign(id, source)

@prop_assign(id, target)

@prop_strong(NSString *, name)

@prop_strong(id, object)

- (void)send;

- (BOOL)isName:(NSString *)name;

- (BOOL)isType:(NSString *)type;

@end
