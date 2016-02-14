//
//  SystemUtil.m
//  Framework
//
//  Created by wuyong on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "SystemUtil.h"

@implementation SystemUtil

+ (NSString *)homePath
{
    return NSHomeDirectory();
}

+ (NSString *)searchPath:(NSSearchPathDirectory)directory
{
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)desktopPath
{
    return [self searchPath:NSDesktopDirectory];
}

+ (NSString *)documentPath
{
    return [self searchPath:NSDocumentDirectory];
}

+ (NSString *)cachesPath
{
    return [self searchPath:NSCachesDirectory];
}

+ (NSString *)libraryPath
{
    return [self searchPath:NSLibraryDirectory];
}

+ (NSString *)preferencePath
{
    return [[self libraryPath] stringByAppendingFormat:@"/Preference"];
}

+ (NSString *)tmpPath
{
    return [[self libraryPath] stringByAppendingFormat:@"/tmp"];
}

+ (NSString *)appPath
{
    return [[NSBundle mainBundle] bundlePath];
}

+ (NSString *)resourcePath
{
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString *)appVersion
{
    NSString * value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if ( nil == value || 0 == value.length ) {
        value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersion"];
    }
    return value;
}

+ (NSString *)appIdentifier
{
    NSString *value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return value;
}

+ (BOOL)isJailbreak
{
    static const char * jbApps[] = {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    // method 1
    for ( int i = 0; jbApps[i]; ++i ) {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jbApps[i]]] ) {
            return YES;
        }
    }
    
    // method 2
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ) {
        return YES;
    }
    
    // method 3
    if ( 0 == system("ls") ) {
        return YES;
    }
    
    return NO;
}

@end
