//
//  FWDefine.h
//  Framework
//
//  Created by 吴勇 on 16/2/14.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#ifndef FWDefine_h
#define FWDefine_h


//@weakify
#ifndef	weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

//@strongify
#ifndef	strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif

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

//@prop
#if __has_feature(objc_arc)

#define	prop_readonly( type, name )		property (nonatomic, readonly) type name;
#define	prop_dynamic( type, name )		property (nonatomic, strong) type name;
#define	prop_assign( type, name )		property (nonatomic, assign) type name;
#define	prop_strong( type, name )		property (nonatomic, strong) type name;
#define	prop_weak( type, name )			property (nonatomic, weak) type name;
#define	prop_copy( type, name )			property (nonatomic, copy) type name;
#define	prop_unsafe( type, name )		property (nonatomic, unsafe_unretained) type name;

#else

#define	prop_readonly( type, name )		property (nonatomic, readonly) type name;
#define	prop_dynamic( type, name )		property (nonatomic, retain) type name;
#define	prop_assign( type, name )		property (nonatomic, assign) type name;
#define	prop_strong( type, name )		property (nonatomic, retain) type name;
#define	prop_weak( type, name )			property (nonatomic, assign) type name;
#define	prop_copy( type, name )			property (nonatomic, copy) type name;
#define	prop_unsafe( type, name )		property (nonatomic, assign) type name;

#endif

//@def_prop
#import "NSObject+Framework.h"
#define def_prop_readonly( type, name ) \
synthesize name = _##name;

#define def_prop_assign( type, name ) \
synthesize name = _##name;

#define def_prop_strong( type, name ) \
synthesize name = _##name;

#define def_prop_weak( type, name ) \
synthesize name = _##name;

#define def_prop_unsafe( type, name ) \
synthesize name = _##name;

#define def_prop_copy( type, name ) \
synthesize name = _##name;

#define def_prop_dynamic( type, name ) \
dynamic name;

#define def_prop_dynamic_copy( type, name, setName ) \
def_prop_custom( type, name, setName, copy )

#define def_prop_dynamic_strong( type, name, setName ) \
def_prop_custom( type, name, setName, retain )

#define def_prop_dynamic_unsafe( type, name, setName ) \
def_prop_custom( type, name, setName, assign )

#define def_prop_dynamic_weak( type, name, setName ) \
def_prop_custom( type, name, setName, assign )

#define def_prop_dynamic_pod( type, name, setName, pod_type ) \
dynamic name; \
- (type)name { return (type)[[self getAssociatedObjectForKey:#name] pod_type##Value]; } \
- (void)setName:(type)obj { [self assignAssociatedObject:@((pod_type)obj) forKey:#name]; }

#define def_prop_custom( type, name, setName, attr ) \
dynamic name; \
- (type)name { return [self getAssociatedObjectForKey:#name]; } \
- (void)setName:(type)obj { [self attr##AssociatedObject:obj forKey:#name]; }


#endif /* FWDefine_h */
