//
//  UIView+Xml.h
//  Framework
//
//  Created by wuyong on 16/1/20.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//视图初始化成功回调
typedef void (^ViewXmlCallback)(UIView *view);

@interface UIView (Xml)

+ (UIView *)viewWithString:(NSString *)string;

+ (UIView *)viewWithFile:(NSString *)file;

+ (UIView *)viewWithName:(NSString *)name;

+ (void)viewWithUrl:(NSString *)url callback:(ViewXmlCallback)callback;

+ (NSString *)joinPath:(NSString *)basePath path:(NSString *)path;

@end
