//
//  ThemeUtil.m
//  LttMember
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "ThemeUtil.h"
#import "UIColor+Hex.h"

static NSMutableDictionary *themes = nil;
static NSString *theme = nil;

@implementation ThemeUtil

+ (void)setThemeFile:(NSString *)file
{
    themes = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
}

+ (void)defineTheme:(NSString *)name definition:(NSDictionary *)definition
{
    if (!themes) {
        themes = [[NSMutableDictionary alloc] init];
    }
    themes[name] = definition;
}

+ (void)setTheme:(NSString *)name
{
    theme = name;
}

+ (NSDictionary *)definition
{
    if (!themes) {
        [self setThemeFile:[[NSBundle mainBundle] pathForResource:@"ThemePlist" ofType:@"plist"]];
    }
    if (!theme) {
        [self setTheme:@"Default"];
    }
    return themes ? [themes objectForKey:theme] : nil;
}

+ (UIColor *)color:(NSString *)key
{
    NSDictionary *definition = [self definition];
    NSString *color = definition ? [definition objectForKey:key] : nil;
    return color ? [UIColor colorWithHexString:color] : nil;
}

@end
