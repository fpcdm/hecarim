//
//  DebugUtil.m
//  LttMember
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "DebugUtil.h"
#import "FrameworkConfig.h"

#ifdef APP_DEBUG
#import "FLEX.h"

#import <sys/sysctl.h>
#import <mach/mach.h>
#endif

static DebugUtil *sharedInstance = nil;

@implementation DebugUtil
{
    NSMutableDictionary *benchmarks;
    NSMutableDictionary *memorys;
}

+ (DebugUtil *) sharedInstance
{
    //多线程唯一
    @synchronized(self){
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        benchmarks = [[NSMutableDictionary alloc] init];
        memorys = [[NSMutableDictionary alloc] init];
#ifdef APP_DEBUG
        [[FLEXManager sharedManager] setNetworkDebuggingEnabled:YES];
#endif
    }
    return self;
}

#ifdef APP_DEBUG
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}
#endif

- (void)benchmarkStart:(NSString *)name
{
#ifdef APP_DEBUG
    NSDate *now = [NSDate date];
    benchmarks[name] = now;
    
    double memory = [self usedMemory];
    if (memory == NSNotFound) memory = 0;
    memorys[name] = @(memory);
    
    NSLog(@"BENCHMARK-START-%@: %.3fs %.3fMB", name, [now timeIntervalSince1970], memory);
#endif
}

- (void)benchmarkEnd:(NSString *)name
{
#ifdef APP_DEBUG
    NSDate *now = [NSDate date];
    
    double memory = [self usedMemory];
    if (memory == NSNotFound) memory = 0;
    
    NSLog(@"BENCHMARK-END-%@: %.3fs %.3fMB", name, [now timeIntervalSince1970], memory);
    
    NSDate *timeStart = [benchmarks objectForKey:name];
    if (!timeStart) return;
    NSNumber *memoryStart = [memorys objectForKey:name];
    
    //获取间隔
    float timeInterval = [now timeIntervalSince1970] - [timeStart timeIntervalSince1970];
    double memoryInterval = memory - [memoryStart doubleValue];
    NSLog(@"BENCHMARK-INFO-%@: %.3fs %.3fMB", name, timeInterval, memoryInterval);
#endif
}

- (void)showFlex
{
#ifdef APP_DEBUG
    [[FLEXManager sharedManager] showExplorer];
#endif
}

- (void)hideFlex
{
#ifdef APP_DEBUG
    [[FLEXManager sharedManager] hideExplorer];
#endif
}

- (void)toggleFlex
{
#ifdef APP_DEBUG
    [[FLEXManager sharedManager] toggleExplorer];
#endif
}

@end
