//
//  FWSingleton.h
//  Framework
//
//  Created by 吴勇 on 16/2/23.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#ifndef FWSingleton_h
#define FWSingleton_h


#pragma mark - singleton
//@singleton
#undef	singleton
#define singleton( __class ) \
    property (nonatomic, readonly) __class * sharedInstance; \
    - (__class *)sharedInstance; \
    + (__class *)sharedInstance;

//@def_singleton
#undef	def_singleton
#define def_singleton( __class ) \
    dynamic sharedInstance; \
    - (__class *)sharedInstance \
    { \
        return [__class sharedInstance]; \
    } \
    + (__class *)sharedInstance \
    { \
        static dispatch_once_t once; \
        static __strong id __singleton__ = nil; \
        dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
        return __singleton__; \
    }

#pragma mark - protocol
/**
 * 单例协议
 */
@protocol FWProtocolSingleton <NSObject>

@required
+ (instancetype) sharedInstance;

@end


#endif /* FWSingleton_h */
