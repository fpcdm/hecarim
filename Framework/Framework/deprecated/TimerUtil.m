//
//  TimerUtil.m
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "TimerUtil.h"

@implementation FWHelperTimer (Interval)

+ (NSTimeInterval) timeInterval: (NSDate *) time
{
    return time ? [[NSDate date] timeIntervalSinceDate:time] : 0;
}

+ (void) test
{
    //声明静态，防止ARC自动释放，也可以放在类变量
    //不声明静态只会执行一次
    static TimerUtil *timer;
    __block int n = 0;
    timer = [TimerUtil repeatTimer:5 block:^(void){
        n++;
        NSLog(@"Hello");
        if (n == 5) {
            NSLog(@"Finish");
            [timer invalidate];
        }
    }];
}

@end
