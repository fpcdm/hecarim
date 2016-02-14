//
//  FWEntity.h
//  Framework
//
//  Created by 吴勇 on 16/2/14.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "JSONModel.h"

@interface FWEntity : JSONModel

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (void)mergeFromDictionary:(NSDictionary *)dict;

@end
