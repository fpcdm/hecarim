//
//  FileEntity.m
//  LttFramework
//
//  Created by wuyong on 15/7/10.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "FileEntity.h"

@implementation FileEntity

@synthesize id;

@synthesize name;

@synthesize data;

@synthesize url;

@synthesize mime;

@synthesize field;

@synthesize remark;

- (void) fromImage:(UIImage *)image
{
    self.data = UIImageJPEGRepresentation(image, 1.0);
}

- (UIImage *) toImage
{
    return [UIImage imageWithData:self.data];
}

@end
