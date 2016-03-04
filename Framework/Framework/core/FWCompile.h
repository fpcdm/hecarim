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
//macro_first
#define macro_first(...) \
    macro_first_( __VA_ARGS__, 0 )
#define macro_first_( A, ... ) \
    A

//macro_last
#define macro_last(...) \
    macro_last_( __VA_ARGS__, nil )
#define macro_last_( A, ... ) \
    __VA_ARGS__

//macro_concat
#define macro_concat( A, B ) \
    macro_concat_( A, B )
#define macro_concat_( A, B ) \
    A##B

//macro_cstr
#define macro_cstr( A ) \
    macro_cstr_( A )
#define macro_cstr_( A ) \
    #A

//macro_string
#define macro_string( A ) \
    macro_string_(A)
#define macro_string_( A ) \
    @(#A)

//macro_count
#define macro_count(...) \
    macro_at( 8, __VA_ARGS__, 8, 7, 6, 5, 4, 3, 2, 1 )

//macro_at
#define macro_at0(...) \
    macro_first(__VA_ARGS__)
#define macro_at1(_0, ...) \
    macro_first(__VA_ARGS__)
#define macro_at2(_0, _1, ...) \
    macro_first(__VA_ARGS__)
#define macro_at3(_0, _1, _2, ...) \
    macro_first(__VA_ARGS__)
#define macro_at4(_0, _1, _2, _3, ...) \
    macro_first(__VA_ARGS__)
#define macro_at5(_0, _1, _2, _3, _4 ...) \
    macro_first(__VA_ARGS__)
#define macro_at6(_0, _1, _2, _3, _4, _5 ...) \
    macro_first(__VA_ARGS__)
#define macro_at7(_0, _1, _2, _3, _4, _5, _6 ...) \
    macro_first(__VA_ARGS__)
#define macro_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...) \
    macro_first(__VA_ARGS__)
#define macro_at(N, ...) \
    macro_concat(macro_at, N)( __VA_ARGS__ )

//macro_method
#define macro_method( ... ) \
    macro_concat(macro_join, macro_count(__VA_ARGS__))(____, __VA_ARGS__)

//macro_join
#define macro_join0( ... )
#define macro_join1( X, A ) \
    A
#define macro_join2( X, A, B ) \
    A##X##B
#define macro_join3( X, A, B, C ) \
    A##X##B##X##C
#define macro_join4( X, A, B, C, D ) \
    A##X##B##X##C##X##D
#define macro_join5( X, A, B, C, D, E ) \
    A##X##B##X##C##X##D##X##E
#define macro_join6( X, A, B, C, D, E, F ) \
    A##X##B##X##C##X##D##X##E##X##F
#define macro_join7( X, A, B, C, D, E, F, G ) \
    A##X##B##X##C##X##D##X##E##X##F##X##G
#define macro_join8( X, A, B, C, D, E, F, G, H ) \
    A##X##B##X##C##X##D##X##E##X##F##X##G##X##H
#define macro_join( X, ... ) \
    macro_concat(macro_join, macro_count(__VA_ARGS__))(X, __VA_ARGS__)

//macro_make
#define macro_make0( ... )
#define macro_make1( A ) \
    A
#define macro_make2( A, B ) \
    A.B
#define macro_make3( A, B, C ) \
    A.B.C
#define macro_make4( A, B, C, D ) \
    A.B.C.D
#define macro_make5( A, B, C, D, E ) \
    A.B.C.D.E
#define macro_make6( A, B, C, D, E, F ) \
    A.B.C.D.E.F
#define macro_make7( A, B, C, D, E, F, G ) \
    A.B.C.D.E.F.G
#define macro_make8( A, B, C, D, E, F, G, H ) \
    A.B.C.D.E.F.G.H
#define macro_make( ... ) \
    macro_concat(macro_make, macro_count(__VA_ARGS__))(__VA_ARGS__)

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

#pragma mark - framework
//FWLOG_
#ifndef FWLOG_
#define FWLOG_( type, ... ) \
    [FWLog type:[NSString stringWithFormat:@"(%@ #%@) %@", [@(__FILE__) lastPathComponent], @(__LINE__), macro_first(__VA_ARGS__)], macro_last(__VA_ARGS__)];
#endif

//FWLOG
#ifndef	FWLOG
#define FWLOG( ... ) \
    FWLOG_(log, __VA_ARGS__)
#endif

//FWVERBOSE
#ifndef	FWVERBOSE
#define FWVERBOSE( ... ) \
    FWLOG_(verbose, __VA_ARGS__)
#endif

//FWDEBUG
#ifndef	FWDEBUG
#define FWDEBUG( ... ) \
    FWLOG_(debug, __VA_ARGS__)
#endif

//FWINFO
#ifndef	FWINFO
#define FWINFO( ... ) \
    FWLOG_(info, __VA_ARGS__)
#endif

//FWWARN
#ifndef	FWWARN
#define FWWARN( ... ) \
    FWLOG_(warn, __VA_ARGS__)
#endif

//FWERROR
#ifndef	FWERROR
#define FWERROR( ... ) \
    FWLOG_(error, __VA_ARGS__)
#endif

//FWDUMP
#ifndef	FWDUMP
#define FWDUMP( ... ) \
    FWLOG_(dump, __VA_ARGS__)
#endif


#endif /* FWCompile_h */
