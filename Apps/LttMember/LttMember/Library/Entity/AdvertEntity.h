//
//  AdvertEntity.h
//  LttMember
//
//  Created by wuyong on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface AdvertEntity : BaseEntity

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *image;

- (void) imageView: (UIImageView *)view;

@end
