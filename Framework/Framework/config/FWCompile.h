//
//  FWCompile.h
//  Framework
//
//  Created by wuyong on 16/2/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#ifndef FWCompile_h
#define FWCompile_h


#pragma mark - global
//macro_cstr
#define macro_cstr( x ) \
    #x

//macro_string
#define macro_string( x ) \
    @(#x)

//macro_concat
#define macro_concat( x, y ) \
    x##y

#pragma mark - custom
//DEPRECATED
#ifndef	DEPRECATED
#define	DEPRECATED \
    __attribute__((deprecated))
#endif

//DEPRECATED_MESSAGE
#define DEPRECATED_MESSAGE( x ) \
    __attribute__((deprecated(x)))

//IGNORED_SELECTOR
#define IGNORED_SELECTOR \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")

//IGNORED_END
#define IGNORED_END \
    _Pragma("clang diagnostic pop")

//UNUSED
#ifndef	UNUSED
#define	UNUSED( __x ) \
    { id __unused_var__ __attribute__((unused)) = (id)(__x); }
#endif

//TODO
#ifndef	TODO
#define TODO( x ) \
    _Pragma(macro_cstr(message("✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖ TODO: " x)))
#endif

#pragma mark - block
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


#endif /* FWCompile_h */
