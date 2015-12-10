//
//  FrontendStyle.m
//  LttMember
//
//  Created by wuyong on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "FrontendCss.h"
#import "UIColor+Frontend.h"

static NSMutableDictionary *globalDefines = nil;

@implementation FrontendCss
{
    NSMutableDictionary *defines;
    NSMutableArray *classes;
    
    NSMutableDictionary *csses;
}

@synthesize view;

- (id)initWithView:(UIView *)_view
{
    self = [super init];
    if (self) {
        view = _view;
    }
    return self;
}

#pragma mark - define
+ (void)defineGlobalClass:(NSString *)name styles:(NSDictionary *)styles
{
    //初始化字典
    if (!globalDefines) {
        globalDefines = [[NSMutableDictionary alloc] init];
    }
    
    //设置样式
    if (styles) {
        [globalDefines setObject:styles forKey:name];
    } else {
        [globalDefines removeObjectForKey:name];
    }
}

+ (NSDictionary *)globalClassForName:(NSString *)name
{
    if (globalDefines) {
        NSDictionary *styles = [globalDefines objectForKey:name];
        return styles ? styles : nil;
    } else {
        return nil;
    }
}

+ (void)clearGlobalDefines
{
    if (globalDefines) {
        [globalDefines removeAllObjects];
    }
}

- (void)defineClass:(NSString *)name styles:(NSDictionary *)styles
{
    if (styles) {
        [defines setObject:styles forKey:name];
    } else {
        [defines removeObjectForKey:name];
    }
}

- (NSDictionary *)classForName:(NSString *)name
{
    //获取全局样式
    NSDictionary *globalStyles = globalDefines ? [globalDefines objectForKey:name] : nil;
    //获取局部样式
    NSDictionary *styles = [defines objectForKey:name];
    
    //合并样式
    if (globalStyles && styles) {
        NSMutableDictionary *allStyles = [NSMutableDictionary dictionaryWithDictionary:globalStyles];
        [allStyles addEntriesFromDictionary:styles];
        return allStyles;
    } else {
        return globalStyles ? globalStyles : styles;
    }
}

- (void)clearDefines
{
    if (defines) {
        [defines removeAllObjects];
    }
}

#pragma mark - apply
- (void)setClasses:(NSArray *)names
{
    
}

- (BOOL)hasClass:(NSString *)name
{
    return NO;
}

- (void)addClass:(NSString *)name
{
    
}

- (void)removeClass:(NSString *)name
{
    
}

- (void)toggleClass:(NSString *)name
{
    
}

- (NSString *)propertyForStyle:(NSString *)name
{
    static dispatch_once_t once;
    static NSDictionary *styleNames = nil;
    
    dispatch_once(&once, ^{
        styleNames = @{
                       @"background" : @"",
                       @"background-color" : @"backgroundColor",
                       @"background-image" : @"backgroundImage",
                       @"width": @"",
                       @"height": @"",
                       @"z-index": @"zIndex",
                       @"display": @"",
                       @"color": @"",
                       @"opacity": @"",
                       @"font": @"",
                       @"font-size": @"fontSize",
                       @"font-weight": @"fontWeight",
                       @"border": @"",
                       @"border-width": @"borderWidth",
                       @"border-color": @"borderColor",
                       @"border-radius": @"borderRadius",
                       @"text-align": @"textAlign",
                       @"text-decoration": @"textDecoration",
                       @"position": @"",
                       @"top": @"",
                       @"left": @"",
                       @"bottom": @"",
                       @"right": @"",
                       @"margin": @"",
                       @"margin-top": @"",
                       @"margin-left": @"",
                       @"margin-bottom": @"",
                       @"margin-right": @"",
                       @"padding": @"",
                       @"padding-top": @"",
                       @"padding-left": @"",
                       @"padding-bottom": @"",
                       @"padding-right": @"",
                       };
    });
    
    //属性不存在
    NSString *property = [styleNames objectForKey:name];
    if (!property) return nil;
    
    return property.length < 1 ? name : property;
}

- (NSString *)css:(NSString *)name
{
    if (!name) return nil;
    
    //查找属性
    NSString *property = [self propertyForStyle:name];
    if (!property) return nil;
    
    //获取属性
    NSString *value = nil;
    if (csses) {
        value = [csses objectForKey:property];
    }
    
    //获取默认值
    if (!value) {
        SEL selector = NSSelectorFromString(property);
        if ([self respondsToSelector:selector]) {
            value = [self performSelector:selector];
        }
    }
    return value;
}

- (void)setCss:(NSString *)name value:(NSString *)value
{
    if (!name || !value) return;
    
    //查找属性
    NSString *property = [self propertyForStyle:name];
    if (!property) return;
    
    //设置属性
    if (!csses) csses = [[NSMutableDictionary alloc] init];
    [csses setObject:value forKey:property];
    
    //调用方法
    NSString *selectorString = [NSString stringWithFormat:@"set%@%@:",
                                [[property substringToIndex:1] uppercaseString],
                                [property substringFromIndex:1]];
    SEL selector = NSSelectorFromString(selectorString);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:value];
    }
}

- (void)setCss:(NSDictionary *)values
{
    if (!values) return;
    
    //循环设置
    for (NSString *name in values) {
        [self setCss:name value:values[name]];
    }
}

#pragma mark - view
- (UILabel *)labelView
{
    if ([view isKindOfClass:[UILabel class]]) {
        return (UILabel *)view;
    }
    return nil;
}

- (UIButton *)buttonView
{
    if ([view isKindOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }
    return nil;
}

- (UITextField *)textFieldView
{
    if ([view isKindOfClass:[UITextField class]]) {
        return (UITextField *)view;
    }
    return nil;
}

- (UITextView *)textView
{
    if ([view isKindOfClass:[UITextView class]]) {
        return (UITextView *)view;
    }
    return nil;
}

- (UIImageView *)imageView
{
    if ([view isKindOfClass:[UIImageView class]]) {
        return (UIImageView *)view;
    }
    return nil;
}

#pragma mark - style
- (NSString *)background
{
    return [self backgroundColor];
}

- (void)setBackground:(NSString *)background
{
    [self setBackgroundColor:background];
}

- (NSString *)backgroundColor
{
    return nil;
}

- (void)setBackgroundColor:(NSString *)backgroundColor
{
    view.backgroundColor = [UIColor colorWithValue:backgroundColor];
}

- (NSString *)color
{
    return nil;
}

- (void)setColor:(NSString *)color
{
    UILabel *labelView = [self labelView];
    if (labelView) {
        labelView.textColor = [UIColor colorWithValue:color];
    }
}

- (NSString *)opacity
{
    return nil;
}

- (void)setOpacity:(NSString *)opacity
{
    view.layer.opacity = [opacity floatValue];
}

- (NSString *)fontSize
{
    return nil;
}

- (void)setFontSize:(NSString *)fontSize
{
    UIFont *font = nil;
    NSString *fontWeight = [self css:@"font-weight"];
    if (fontWeight && [@"bold" isEqualToString:fontWeight]) {
        font = [UIFont boldSystemFontOfSize:[fontSize floatValue]];
    } else {
        font = [UIFont systemFontOfSize:[fontSize floatValue]];
    }
    
    UILabel *labelView = [self labelView];
    if (labelView) {
        labelView.font = font;
    }
}

- (NSString *)fontWeight
{
    return nil;
}

- (void)setFontWeight:(NSString *)fontWeight
{
    UIFont *font = nil;
    NSString *fontSize = [self css:@"font-size"];
    if (!fontSize) {
        fontSize = [NSString stringWithFormat:@"%lf", [UIFont systemFontSize]];
    }
    if ([@"bold" isEqualToString:fontWeight]) {
        font = [UIFont boldSystemFontOfSize:[fontSize floatValue]];
    } else {
        font = [UIFont systemFontOfSize:[fontSize floatValue]];
    }
    
    UILabel *labelView = [self labelView];
    if (labelView) {
        labelView.font = font;
    }
}

- (NSString *)borderWidth
{
    return nil;
}

- (void)setBorderWidth:(NSString *)borderWidth
{
    view.layer.borderWidth = [borderWidth floatValue];
}

- (NSString *)borderColor
{
    return nil;
}

- (void)setBorderColor:(NSString *)borderColor
{
    UIColor *color = [UIColor colorWithValue:borderColor];
    view.layer.borderColor = color ? color.CGColor : nil;
}

- (NSString *)borderRadius
{
    return nil;
}

- (void)setBorderRadius:(NSString *)borderRadius
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = [borderRadius floatValue];
}

- (NSString *)textAlign
{
    return nil;
}

- (void)setTextAlign:(NSString *)textAlign
{
    NSTextAlignment textAlignment = -1;
    BOOL hasValue = NO;
    if ([@"center" isEqualToString:textAlign]) {
        textAlignment = NSTextAlignmentCenter;
        hasValue = YES;
    } else if ([@"left" isEqualToString:textAlign]) {
        textAlignment = NSTextAlignmentLeft;
        hasValue = YES;
    } else if ([@"right" isEqualToString:textAlign]) {
        textAlignment = NSTextAlignmentRight;
        hasValue = YES;
    }
    
    if (hasValue) {
        UILabel *labelView = [self labelView];
        if (labelView) {
            labelView.textAlignment = textAlignment;
        }
    }
}

@end
