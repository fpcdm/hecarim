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

@synthesize path;

- (instancetype) initWithData:(NSData *)fileData
{
    self = [super init];
    if (!self) return nil;
    
    self.data = fileData;
    
    return self;
}

- (instancetype) initWithImage:(UIImage *)image compression:(CGFloat)compression
{
    self = [super init];
    if (!self) return nil;
    
    [self setImage:image compression:compression];
    
    return self;
}

- (instancetype) initWithImage:(UIImage *)image
{
    return [self initWithImage:image compression:1.0];
}

- (instancetype) initWithPath:(NSString *)filePath
{
    self = [super init];
    if (!self) return nil;
    
    self.data = [NSData dataWithContentsOfFile:filePath];
    self.path = filePath;
    
    return self;
}

- (void) setImage:(UIImage *)image compression:(CGFloat)compression
{
    self.data = UIImageJPEGRepresentation(image, compression);
    self.mime = @"image/jpeg";
}

- (void) setImage:(UIImage *)image
{
    [self setImage:image compression:1.0];
}

- (UIImage *) image
{
    return [UIImage imageWithData:self.data];
}

@end
