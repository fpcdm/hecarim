//
//  FileEntity.h
//  LttFramework
//
//  Created by wuyong on 15/7/10.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseEntity.h"
#import <UIKit/UIKit.h>

@interface FileEntity : BaseEntity

@property (retain, nonatomic) NSString *id;

@property (retain, nonatomic) NSData *data;

@property (retain, nonatomic) NSString *name;

@property (retain, nonatomic) NSString *remark;

@property (retain, nonatomic) NSString *url;

@property (retain, nonatomic) NSString *field;

@property (retain, nonatomic) NSString *mime;

- (void) fromImage: (UIImage *) image;

- (UIImage *) toImage;

@end
