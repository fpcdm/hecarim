//
//  TimerUtil.h
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerUtil : NSObject

//默认并列队列
+ (TimerUtil *) repeatTimer: (NSTimeInterval) seconds block: (void(^)(void)) block;

//自定义队列
+ (TimerUtil *) repeatTimer: (NSTimeInterval) seconds block: (void(^)(void)) block queue:(dispatch_queue_t) queue;

- (void) suspend;

- (void) resume;

- (void)invalidate;

+ (void) test;

@end
