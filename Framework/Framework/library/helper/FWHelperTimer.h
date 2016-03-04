//
//  FWHelperTimer.h
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//为防止block获取不到Timer，可声明为静态变量或者类变量，否则invalidate无效
@interface FWHelperTimer : NSObject

//默认并列队列
+ (instancetype) timerWithInterval:(NSTimeInterval)interval block:(void(^)(void))block;

//自定义队列
+ (instancetype) timerWithInterval:(NSTimeInterval)interval block:(void (^)(void))block queue:(dispatch_queue_t) queue;

- (void) suspend;

- (void) resume;

- (void) invalidate;

@end
