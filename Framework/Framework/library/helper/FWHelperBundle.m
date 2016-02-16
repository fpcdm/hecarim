//
//  FWHelperBundle.m
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHelperBundle.h"

@implementation FWHelperBundle

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

@end
