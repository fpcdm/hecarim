//
//  LogUtil.h
//  LttMember
//
//  Created by wuyong on 16/1/6.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LogTypeLog = 0,
    LogTypeDebug,
    LogTypeInfo,
    LogTypeWarn,
    LogTypeError
} LogType;

@interface LogUtil : NSObject

+ (void)log:(LogType)type format:(NSString *)format, ...;

+ (void)log:(NSString *)format, ...;

+ (void)debug:(NSString *)format, ...;

+ (void)info:(NSString *)format, ...;

+ (void)warn:(NSString *)format, ...;

+ (void)error:(NSString *)format, ...;

@end
