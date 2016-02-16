//
//  FWProtocol.h
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#ifndef FWProtocol_h
#define FWProtocol_h

/**
 * 单例协议
 */
@protocol FWProtocolSingleton <NSObject>

@required
+ (instancetype) sharedInstance;

@end

/**
 * 观察者协议
 */
@protocol FWProtocolSubject;
@protocol FWProtocolObserver <NSObject>

@required
- (void)update:(id<FWProtocolSubject>)subject;

@end

/**
 * 主题协议
 */
@protocol FWProtocolSubject <NSObject>

@required
- (void)attach:(id<FWProtocolObserver>)observer;
- (void)detach:(id<FWProtocolObserver>)observer;
- (void)notify;

@end

/**
 * 注册表协议
 */
@protocol FWProtocolRegistry <NSObject>

@required
- (id)get:(NSString *)key;
- (BOOL)has:(NSString *)key;
- (void)set:(NSString *)key object:(id)object;
- (void)remove:(NSString *)key;
- (void)clear;

@end

#endif /* FWProtocol_h */
