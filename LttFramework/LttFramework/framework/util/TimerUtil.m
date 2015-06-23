//
//  TimerUtil.m
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "TimerUtil.h"

@interface TimerUtil ()

@property (nonatomic) dispatch_source_t source;

@property (weak) void (^block) (void);

@property (nonatomic, assign) BOOL started;

@end

@implementation TimerUtil

+ (TimerUtil *) repeatTimer: (NSTimeInterval) seconds block: (void(^)(void)) block
{
    //默认并行主队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //自定义队列
    //dispatch_queue_t queue = dispatch_queue_create("timerQueue", 0);
    //串行主队列
    //dispatch_queue_t queue = dispatch_get_main_queue();
    
    return [self repeatTimer:seconds block:block queue:queue];
}

+ (TimerUtil *) repeatTimer:(NSTimeInterval)seconds block:(void (^)(void))block queue:(dispatch_queue_t)queue
{
    NSParameterAssert(seconds);
    NSParameterAssert(block);
    
    TimerUtil *timer = [[self alloc] init];
    timer.started = NO;
    timer.block = block;
    timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t nsec = (uint64_t) (seconds * NSEC_PER_SEC);
    dispatch_source_set_timer(timer.source, dispatch_time(DISPATCH_TIME_NOW, 0), nsec, 0);
    dispatch_source_set_event_handler(timer.source, timer.block);
    
    //自动启动
    [timer resume];
    
    return timer;
}

- (void) suspend
{
    if (self.source && self.started) {
        dispatch_suspend(self.source);
        self.started = NO;
    }
}

- (void) resume
{
    if (self.source && !self.started) {
        dispatch_resume(self.source);
        self.started = YES;
    }
}

- (void)invalidate {
    if (self.source) {
        dispatch_source_cancel(self.source);
        self.source = nil;
    }
    self.block = nil;
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
