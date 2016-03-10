//
//  FWTask.h
//  Framework
//
//  Created by wuyong on 16/3/9.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//任务基类
@interface FWTask : NSOperation

@prop_strong(NSError *, error)

//子类重写，任务执行完成，需调用finishWithError:
- (void)executeTask;

//标记任务完成，error为空表示任务成功
- (void)finishWithError:(NSError *)error;

//是否需要主线程执行，会阻碍UI渲染，默认NO
- (BOOL)needMainThread;

@end

//任务管理器，兼容NSBlockOperation和NSInvocationOperation
@interface FWTaskManager : NSObject

@singleton(FWTaskManager)

//并发操作的最大任务数
@prop_assign(NSInteger, maxConcurrentTaskCount)

//从配置数组添加任务
- (void)addTaskConfig:(NSArray<NSDictionary *> *)config;

//添加单个任务
- (void)addTask:(NSOperation *)task;

//批量添加任务
- (void)addTasks:(NSArray<NSOperation *> *)tasks;

@end
