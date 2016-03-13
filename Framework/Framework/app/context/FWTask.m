//
//  FWTask.m
//  Framework
//
//  Created by wuyong on 16/3/9.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWTask.h"

typedef NS_ENUM(NSInteger, FWTaskState) {
    FWTaskStateCreate,
    FWTaskStateReady = 1,
    FWTaskStateLoading,
    FWTaskStateSuccessed,
    FWTaskStateFailure,
    FWTaskStateCanceled,
};

@interface FWTask ()

@property (nonatomic, assign) FWTaskState state;
@property (nonatomic, strong, readonly) NSRecursiveLock *lock;

@end

@implementation FWTask

@synthesize lock = _lock;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.state = FWTaskStateReady;
    }
    return self;
}

- (NSRecursiveLock *)lock
{
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

- (void)start
{
    [self.lock lock];
    if ([self isReady]) {
        self.state = FWTaskStateLoading;
        [FWLog debug:@"task %@ start", [self.class description]];
        [self.lock unlock];
        
        if ([self needMainThread]) {
            if ([NSThread isMainThread]) {
                [self executeTask];
            } else {
                [self performSelectorOnMainThread:@selector(executeTask) withObject:nil waitUntilDone:NO];
            }
        } else {
            [self executeTask];
        }
    } else {
        [self.lock unlock];
    }
}

- (void)executeTask
{
    @throw [NSException exceptionWithName:FRAMEWORK_EXCEPTION_NAME
                                   reason:[NSString stringWithFormat:@"task %@ must override executeTask", [self.class description]]
                                 userInfo:nil];
}

- (void)finishWithError:(NSError *)error
{
    [self.lock lock];
    if (![self isFinished]) {
        [FWLog debug:@"task %@ finish", [self.class description]];
        if (error) {
            self.error = error;
            self.state = FWTaskStateFailure;
        } else {
            self.state = FWTaskStateSuccessed;
        }
    }
    [self.lock unlock];
}

- (BOOL)needMainThread
{
    return NO;
}

- (void)cancel
{
    [self.lock lock];
    
    if (![self isFinished]) {
        self.state = FWTaskStateCanceled;
        [super cancel];
        [FWLog debug:@"task %@ cancel", [self.class description]];
    }
    
    [self.lock unlock];
}

//isConcurrent < iOS7
- (BOOL)isAsynchronous
{
    return YES;
}

- (BOOL)isReady
{
    return self.state == FWTaskStateReady && [super isReady];
}

- (BOOL)isFinished
{
    return self.state == FWTaskStateSuccessed || self.state == FWTaskStateFailure || self.state == FWTaskStateCanceled;
}

- (BOOL)isExecuting
{
    return self.state == FWTaskStateLoading;
}

- (BOOL)isValidTransition:(FWTaskState)fromState toState:(FWTaskState)toState
{
    switch (fromState) {
        case FWTaskStateReady:
        {
            switch (toState) {
                case FWTaskStateLoading:
                case FWTaskStateSuccessed:
                case FWTaskStateFailure:
                case FWTaskStateCanceled:
                    return YES;
                    break;
                default:
                    return NO;
                    break;
            }
            break;
        }
        case FWTaskStateLoading:
        {
            switch (toState) {
                case FWTaskStateSuccessed:
                case FWTaskStateFailure:
                case FWTaskStateCanceled:
                    return YES;
                    break;
                default:
                    return NO;
                    break;
            }
        }
        case (FWTaskState)0:
        {
            if (toState == FWTaskStateReady) {
                return YES;
            } else {
                return NO;
            }
        }
        default:
            return NO;
            break;
    }
}

- (void)setState:(FWTaskState)state
{
    [self.lock lock];
    if (![self isValidTransition:_state toState:state]) {
        [self.lock unlock];
        return;
    }
    
    switch (state) {
        case FWTaskStateCanceled:
        {
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            [self willChangeValueForKey:@"isCancelled"];
            _state = state;
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
            [self didChangeValueForKey:@"isCancelled"];
            break;
        }
        case FWTaskStateLoading:
        {
            [self willChangeValueForKey:@"isExecuting"];
            _state = state;
            [self didChangeValueForKey:@"isExecuting"];
            break;
        }
        case FWTaskStateSuccessed:
        case FWTaskStateFailure:
        {
            [self willChangeValueForKey:@"isFinished"];
            [self willChangeValueForKey:@"isExecuting"];
            _state = state;
            [self didChangeValueForKey:@"isFinished"];
            [self didChangeValueForKey:@"isExecuting"];
            break;
        }
        case FWTaskStateReady:
        {
            [self willChangeValueForKey:@"isReady"];
            _state = state;
            [self didChangeValueForKey:@"isReady"];
            break;
        }
        default:
        {
            _state = state;
            break;
        }
    }
    
    [self.lock unlock];
}

@end

#pragma mark -
@implementation FWTaskManager
{
    NSOperationQueue *_taskQueue;
}

@def_singleton(FWTaskManager)

- (id)init
{
    self = [super init];
    if (self) {
        _taskQueue = [[NSOperationQueue alloc] init];
        _taskQueue.name = @"FWTaskManager.taskQueue";
    }
    return self;
}

- (void)setMaxConcurrentTaskCount:(NSInteger)maxConcurrentTaskCount
{
    _taskQueue.maxConcurrentOperationCount = maxConcurrentTaskCount;
}

- (NSInteger)maxConcurrentTaskCount
{
    return _taskQueue.maxConcurrentOperationCount;
}

- (void)addTaskConfig:(NSArray<NSDictionary *> *)config
{
    NSMutableDictionary *taskMap = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *taskInfo in config) {
        //className
        NSString *className = [taskInfo objectForKey:@"className"];
        Class clazz = NSClassFromString(className);
        if ([clazz isSubclassOfClass:[NSOperation class]]) {
            NSOperation *task = [[clazz alloc] init];
            [taskMap setObject:task forKey:className];
            //dependency
            NSArray *dependencyList = [[taskInfo objectForKey:@"dependency"] componentsSeparatedByString:@","];
            if (dependencyList.count) {
                for (NSString *depedencyClass in dependencyList) {
                    NSOperation *preTask = [taskMap objectForKey:depedencyClass];
                    if (preTask) [task addDependency:preTask];
                }
            }
        }
    }
    
    [self addTasks:[taskMap allValues]];
}

- (void)addTasks:(NSArray<NSOperation *> *)tasks
{
    if (tasks.count) {
        [_taskQueue addOperations:tasks waitUntilFinished:NO];
    }
}

- (void)addTask:(NSOperation *)task
{
    [_taskQueue addOperation:task];
}

@end
