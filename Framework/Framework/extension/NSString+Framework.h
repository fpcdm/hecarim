//
//  NSString+Framework.h
//  Framework
//
//  Created by wuyong on 16/2/17.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Framework)

/**
 *  去掉空白字符
 */
- (NSString *)trim;

/**
 *  去掉左侧空白字符
 */
- (NSString *)ltrim;

/**
 *  去掉右侧空白字符
 */
- (NSString *)rtrim;

/**
 *  是否符合正则表达式
 *
 *  @param regex 正则表达式
 */
- (BOOL)isFormatRegex:(NSString *)regex;

/**
 *  是否是手机号
 */
- (BOOL)isFormatMobile;

/**
 *  是否是座机号
 */
- (BOOL)isFormatTelephone;

/**
 *  是否是整数
 */
- (BOOL)isFormatInteger;

/**
 *  是否是数字
 */
- (BOOL)isFormatNumber;

/**
 *  是否是合法金额，两位小数点
 */
- (BOOL)isFormatMoney;

/**
 *  是否是身份证号
 */
- (BOOL)isFormatIdcard;

/**
 *  是否是邮箱
 */
- (BOOL)isFormatEmail;

/**
 *  是否是URL
 */
- (BOOL)isFormatUrl;

/**
 *  是否是IP
 */
- (BOOL)isFormatIp;

/**
 *  是否全是中文
 */
- (BOOL)isFormatChinese;

/**
 *  是否是合法日期，格式：yyyy-MM-dd HH:mm:ss
 */
- (BOOL)isFormatDate;

@end
