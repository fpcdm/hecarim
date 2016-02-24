//
//  FWUnitTest.h
//  Framework
//
//  Created by wuyong on 16/2/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef	TEST_CASE
#define	TEST_CASE( __module, __name ) \
		@interface __TestCase__##__module##_##__name : FWTestCase \
		@end \
		@implementation __TestCase__##__module##_##__name

#undef	TEST_CASE_END
#define	TEST_CASE_END \
		@end

#undef	DESCRIBE
#define	DESCRIBE( __test ) \
		- (void) macro_concat( test, __test )

#undef	EXPECTED
#define EXPECTED( ... ) \
		if ( !(__VA_ARGS__) ) \
		{ \
			@throw [FWTestException expr:#__VA_ARGS__ file:__FILE__ line:__LINE__]; \
		}

#undef	TIMES
#define TIMES( __n ) \
		for ( int __i_##__LINE__ = 0; __i_##__LINE__ < __n; ++__i_##__LINE__ )

#pragma mark -

@interface FWTestException : NSException

@prop_strong(NSString *, expr)
@prop_strong(NSString *, file)
@prop_assign(NSInteger, line)

+ (FWTestException *)expr:(const char *)expr file:(const char *)file line:(int)line;

@end

#pragma mark -

@interface FWTestCase : NSObject

@end

#pragma mark -

@interface FWUnitTest : NSObject

@singleton(FWUnitTest)

- (void)run;

@end
