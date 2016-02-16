//
//  FWHelperTimer.m
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHelperTimer.h"

@interface FWHelperTimer ()

@property (nonatomic) dispatch_source_t source;

@property (copy) void (^block) (void);

@property (nonatomic, assign) BOOL started;

@end

@implementation FWHelperTimer

+ (instancetype) repeatTimer: (NSTimeInterval) seconds block: (void(^)(void)) block
{
    //默认并行主队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //自定义队列
    //dispatch_queue_t queue = dispatch_queue_create("timerQueue", 0);
    //串行主队列
    //dispatch_queue_t queue = dispatch_get_main_queue();
    
    return [self repeatTimer:seconds block:block queue:queue];
}

+ (instancetype) repeatTimer:(NSTimeInterval)seconds block:(void (^)(void))block queue:(dispatch_queue_t)queue
{
    NSParameterAssert(seconds);
    NSParameterAssert(block);
    
    FWHelperTimer *timer = [[self alloc] init];
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

- (void) invalidate {
    if (self.source) {
        dispatch_source_cancel(self.source);
        self.source = nil;
    }
    self.block = nil;
}

@end
