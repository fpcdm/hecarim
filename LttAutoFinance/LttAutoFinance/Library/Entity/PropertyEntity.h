//
//  PropertyEntity.h
//  LttAutoFinance
//
//  Created by wuyong on 15/9/28.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface PropertyEntity : BaseEntity

@property (nonatomic, retain) NSNumber *id;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *icon;

- (void)iconView:(UIImageView *)imageView;

@end
