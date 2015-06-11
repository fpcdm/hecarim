//
//  TimerUtil.h
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerUtil : NSObject

+ (TimerUtil *) repeatTimer: (NSTimeInterval) seconds block: (void(^)(void)) block;

- (void) suspend;

- (void) resume;

- (void)invalidate;

+ (void) test;

@end
