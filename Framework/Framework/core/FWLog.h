//
//  FWLog.h
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWLog : NSObject

+ (void)log:(NSString *)format, ...;

+ (void)debug:(NSString *)format, ...;

+ (void)info:(NSString *)format, ...;

+ (void)warn:(NSString *)format, ...;

+ (void)error:(NSString *)format, ...;

/**
 *  调试对象
 */
+ (void)dump:(id)object;

@end
