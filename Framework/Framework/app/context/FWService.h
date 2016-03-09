//
//  FWService.h
//  Framework
//
//  Created by wuyong on 16/3/3.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef  AS_SERVICE
#define AS_SERVICE(prot) \
    + (void)load { [[FWServiceManager sharedInstance] registerService:@protocol(prot) withImpl:[self class]]; }

//服务协议
@protocol FWService <NSObject>

@optional
//服务已加载完成钩子
+ (void)serviceLoaded;

//服务初始化完成钩子
- (void)serviceInited;

@end

//服务管理池
@interface FWServiceManager : NSObject

@singleton(FWServiceManager)

//注册服务类
- (void)registerService:(Protocol *)protocol withImpl:(Class)implClass;

//获取服务对象，延迟加载
- (id)getService:(Protocol *)protocol;

//加载服务列表，由于采用延迟加载，不需要预加载，主要用于调试
- (void)loadServices;

@end
