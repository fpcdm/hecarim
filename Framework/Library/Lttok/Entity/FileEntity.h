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

@property (retain, nonatomic) NSString *path;

- (instancetype) initWithData: (NSData *) data;

- (instancetype) initWithPath: (NSString *) path;

- (instancetype) initWithImage: (UIImage *) image;

- (instancetype) initWithImage: (UIImage *) image compression: (CGFloat) compression;

- (void) setImage:(UIImage *)image compression: (CGFloat) compression;

- (void) setImage:(UIImage *)image;

- (UIImage *) image;

@end
