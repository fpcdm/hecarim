//
//  FWLog.h
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LogTypeLog = 0,
    LogTypeDebug,
    LogTypeInfo,
    LogTypeWarn,
    LogTypeError
} LogType;

@interface FWLog : NSObject

+ (void)log:(LogType)type format:(NSString *)format, ...;

+ (void)log:(NSString *)format, ...;

+ (void)debug:(NSString *)format, ...;

+ (void)info:(NSString *)format, ...;

+ (void)warn:(NSString *)format, ...;

+ (void)error:(NSString *)format, ...;

@end
