//
//  TimerUtil.h
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWHelperTimer.h"

typedef FWHelperTimer TimerUtil;

@interface FWHelperTimer (Interval)

//计算离当前时间的间隔
+ (NSTimeInterval) timeInterval: (NSDate *) time;

+ (void) test;

@end
