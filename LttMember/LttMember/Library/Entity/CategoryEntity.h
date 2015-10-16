//
//  CategoryModel.h
//  LttMember
//
//  Created by wuyong on 15/5/6.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface CategoryEntity : BaseEntity

@property (nonatomic, retain) NSNumber *id;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *icon;

@property (nonatomic, retain) NSString *remark;

@property (nonatomic, retain) NSString *detail;

@property (nonatomic, retain) NSNumber *sort;

- (void) groupIconView: (UIImageView *)view;

- (void) itemIconView: (UIImageView *)view;

@end
