//
//  FWFramework.m
//  Framework
//
//  Created by wuyong on 16/2/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWFramework.h"
#import <sys/utsname.h>

@implementation FWFramework

@def_singleton(FWFramework)

+ (void)load
{
    [FWFramework sharedInstance];
}

- (id)init
{
    self = [super init];
    if (self) {
        //启动系统
        [self startup];
    }
    return self;
}

- (void)startup
{
    struct utsname systemInfo;
    uname( &systemInfo );
    
    const char * options[] = {
        "[Off]",
        "[On]"
    };
    
    fprintf( stderr, "                                                                                   \n" );
    fprintf( stderr, "     ____    _                        __     _      _____                          \n" );
    fprintf( stderr, "    / ___\\  /_\\     /\\/\\    /\\ /\\    /__\\   /_\\     \\_   \\               \n" );
    fprintf( stderr, "    \\ \\    //_\\\\   /    \\  / / \\ \\  / \\//  //_\\\\     / /\\/              \n" );
    fprintf( stderr, "  /\\_\\ \\  /  _  \\ / /\\/\\ \\ \\ \\_/ / / _  \\ /  _  \\ /\\/ /_               \n" );
    fprintf( stderr, "  \\____/  \\_/ \\_/ \\/    \\/  \\___/  \\/ \\_/ \\_/ \\_/ \\____/                \n" );
    fprintf( stderr, "                                                                                   \n" );
    fprintf( stderr, "                                                                                   \n" );
    fprintf( stderr, "  version: %s\n", FRAMEWORK_VERSION );
    fprintf( stderr, "                                                                                   \n" );
    fprintf( stderr, "  - debug:   %s\n", options[FRAMEWORK_DEBUG] );
    fprintf( stderr, "  - logging: %s\n", options[FRAMEWORK_LOG] );
    fprintf( stderr, "  - testing: %s\n", options[FRAMEWORK_TEST] );
    fprintf( stderr, "                                                                                   \n" );
    fprintf( stderr, "  - system:  %s\n", systemInfo.sysname );
    fprintf( stderr, "  - node:    %s\n", systemInfo.nodename );
    fprintf( stderr, "  - release: %s\n", systemInfo.release );
    fprintf( stderr, "  - version: %s\n", systemInfo.version );
    fprintf( stderr, "  - machine: %s\n", systemInfo.machine );
    fprintf( stderr, "                                                                                   \n" );
    fprintf( stderr, "  +----------------------------------------------------------------------------+   \n" );
    fprintf( stderr, "  |                                                                            |   \n" );
    fprintf( stderr, "  |  1. Have a bug or a feature request?                                       |   \n" );
    fprintf( stderr, "  |                                                                            |   \n" );
    fprintf( stderr, "  +----------------------------------------------------------------------------+   \n" );
    fprintf( stderr, "                                                                                   \n" );
    fprintf( stderr, "                                                                                   \n" );
    
#if FRAMEWORK_TEST
    [[FWUnitTest sharedInstance] run];
#endif
}

@end
