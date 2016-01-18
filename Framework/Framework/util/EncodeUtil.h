//
//  StringUtil.h
//  Framework
//
//  Created by wuyong on 16/1/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncodeUtil : NSObject

+ (NSString *)jsonEncode:(id)obj;
+ (id) jsonDecode:(NSString *)str;

+ (NSString *)urlEncode:(NSString *)str;
+ (NSString *)urlDecode:(NSString *)str;

+ (NSString *)base64Encode:(NSString *)str;
+ (NSString *)base64Decode:(NSString *)str;

+ (NSString *)base64EncodeData:(NSData *)data;
+ (NSData *)base64DecodeData:(NSString *)str;

+ (NSString *)md5:(NSString *)str;

@end
