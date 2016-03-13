//
//  FWService.m
//  Framework
//
//  Created by wuyong on 16/3/3.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWService.h"
#import <objc/runtime.h>

@implementation FWServiceManager
{
    //服务已注册类
    NSMutableDictionary *serviceClasses;
    //服务对象缓存池，延迟加载
    NSMutableDictionary *servicePool;
}

@def_singleton(FWServiceManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        serviceClasses = [[NSMutableDictionary alloc] init];
        servicePool = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerService:(Protocol *)protocol withImpl:(Class)implClass
{
    NSParameterAssert(protocol != nil);
    NSParameterAssert(implClass != nil);
    
    //必须实现服务协议(FWService、protocol)
    NSString *protocolName = NSStringFromProtocol(protocol);
    NSString *className = NSStringFromClass(implClass);
    if (![implClass conformsToProtocol:@protocol(FWService)]) {
        @throw [NSException exceptionWithName:FRAMEWORK_EXCEPTION_NAME
                                       reason:[NSString stringWithFormat:@"service %@ must confirms to protocol %@", className, @"FWService"]
                                     userInfo:nil];
    }
    if (![implClass conformsToProtocol:protocol]) {
        @throw [NSException exceptionWithName:FRAMEWORK_EXCEPTION_NAME
                                       reason:[NSString stringWithFormat:@"service %@ must confirms to protocol %@", className, protocolName]
                                     userInfo:nil];
    }
    
    //服务对象已被使用不能修改
    if ([servicePool objectForKey:protocolName]) {
        @throw [NSException exceptionWithName:FRAMEWORK_EXCEPTION_NAME
                                       reason:[NSString stringWithFormat:@"service %@ is already in use", protocolName]
                                     userInfo:nil];
    }
    
    [serviceClasses setObject:className forKey:protocolName];
}

- (id)getService:(Protocol *)protocol
{
    NSString *protocolName = NSStringFromProtocol(protocol);
    id service = [servicePool objectForKey:protocolName];
    if (!service) {
        //是否已注册实现
        NSString *className = [serviceClasses objectForKey:protocolName];
        if (className) {
            Class implClass = NSClassFromString(className);
            //检查serviceLoaded方法
            if (class_respondsToSelector(implClass, @selector(serviceLoaded))) {
                [implClass serviceLoaded];
            }
            //检查sharedInstance方法
            if (class_respondsToSelector(implClass, @selector(sharedInstance))) {
                service = [implClass sharedInstance];
            } else {
                service = [[implClass alloc] init];
            }
            //检查serviceInited方法
            if ([service respondsToSelector:@selector(serviceInited)]) {
                [service serviceInited];
            }
            //设置对象缓存
            [servicePool setObject:service forKey:protocolName];
            
            [FWLog debug:@"service %@ inited with class %@", protocolName, className];
        } else {
            [FWLog warn:@"service %@ not registered", protocolName];
        }
    }
    return service;
}

- (void)loadServices
{
#if FRAMEWORK_DEBUG
    NSMutableString *serviceLog = [NSMutableString string];
    for (NSString *serviceName in serviceClasses) {
        NSString *serviceClass = [serviceClasses objectForKey:serviceName];
        [serviceLog appendFormat:@"%@ : %@\n", serviceName, serviceClass];
    }
    
    NSString *log = [NSString stringWithFormat:@"\n\n\
========== SERVICE ==========\n\
%@\
========== SERVICE ==========\n",
                     serviceLog
                     ];
    [FWLog debug:log];
#endif
}

@end
