//
//  FWHelperPath.m
//  Framework
//
//  Created by 吴勇 on 16/2/22.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHelperPath.h"

@implementation FWHelperPath

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

@end
