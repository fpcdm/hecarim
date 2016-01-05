//
//  ThemeUtil.m
//  LttMember
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "ThemeUtil.h"
#import "UIColor+Hex.h"

static NSDictionary *themes = nil;
static NSString *theme = nil;

@implementation ThemeUtil

+ (void)setThemeFile:(NSString *)file
{
    themes = [[NSDictionary alloc] initWithContentsOfFile:file];
}

+ (void)setTheme:(NSString *)name
{
    theme = name;
}

+ (NSDictionary *)definitions
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
    NSDictionary *definitions = [self definitions];
    NSString *color = definitions ? [definitions objectForKey:key] : nil;
    return color ? [UIColor colorWithHexString:color] : nil;
}

@end
