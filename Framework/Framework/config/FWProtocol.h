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

TODO("signal, same as notification, 不同之处：不传递对象本身，传递signal对象，相互不知道对方，如viewmodel不知道view")

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
