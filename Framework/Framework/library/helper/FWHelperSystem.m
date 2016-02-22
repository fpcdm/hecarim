//
//  FWHelperSystem.m
//  Framework
//
//  Created by 吴勇 on 16/2/22.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHelperSystem.h"

@implementation FWHelperSystem

+ (NSString *)bundleVersion
{
    NSString * value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return value;
}

+ (NSString *)bundleShortVersion
{
    NSString * value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersion"];
    return value;
}

+ (NSString *)bundleIdentifier
{
    NSString *value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return value;
}

+ (NSString *)urlSchema
{
    return [self urlSchema:nil];
}

+ (NSString *)urlSchema:(NSString *)name
{
    NSArray *array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for ( NSDictionary *dict in array ) {
        if ( name ) {
            NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
            if ( nil == URLName ) {
                continue;
            }
            
            if ( NO == [URLName isEqualToString:name] ) {
                continue;
            }
        }
        
        NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if ( nil == URLSchemes || 0 == URLSchemes.count ) {
            continue;
        }
        
        NSString * schema = [URLSchemes objectAtIndex:0];
        if ( schema && schema.length ) {
            return schema;
        }
    }
    
    return nil;
}

+ (NSString *)identifierUUID
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
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
    /*
    if ( 0 == system("ls") ) {
        return YES;
    }
    */
    
    return NO;
}

@end
