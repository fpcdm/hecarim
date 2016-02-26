//
//  FWBooter.m
//  Framework
//
//  Created by wuyong on 16/2/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWBooter.h"

@implementation FWBooter

@def_singleton(FWBooter)

+ (void)load
{
#if FRAMEWORK_DEBUG
    //开启调试，自启动
    [[FWBooter sharedInstance] boot];
#endif
}

- (void)boot
{
#if FRAMEWORK_LOG
    //开启LOG
    [self bootLog];
#endif
    
#if FRAMEWORK_TEST
    //开启测试
    [self bootTest];
#endif
}

#if FRAMEWORK_LOG
- (void)bootLog
{
    NSArray *opts = @[@"NO", @"YES"];
    NSString *log = [NSString stringWithFormat:@"\n\n\
========== FRAMEWORK ==========\n\
 VERSION : %@\n\
   DEBUG : %@\n\
    TEST : %@\n\
     LOG : %@\n\
========== FRAMEWORK ==========\n",
                     FRAMEWORK_VERSION,
                     opts[FRAMEWORK_DEBUG],
                     opts[FRAMEWORK_TEST],
                     opts[FRAMEWORK_LOG]
                     ];
    [FWLog verbose:log];
}
#endif

#if FRAMEWORK_TEST
- (void)bootTest
{
    [[FWUnitTest sharedInstance] run];
}
#endif

@end
