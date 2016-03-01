//
//  AppUIUtil.m
//  LttMember
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppUIUtil.h"
#import "Config.h"
#import "AppExtension.h"

@implementation AppUIUtil

+ (UIBarButtonItem *) makeBarButtonItem: (NSString *) title
{
    return [self makeBarButtonItem:title highlighted:NO];
}

+ (UIBarButtonItem *) makeBarButtonItem: (NSString *) title highlighted:(BOOL) highlighted
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = title;
    
    if (highlighted) {
        barButtonItem.tintColor = COLOR_MAIN_HIGHLIGHT;
    } else {
        barButtonItem.tintColor = COLOR_MAIN_BLACK;
    }
    
    [barButtonItem setTitleTextAttributes:@{
                                            NSFontAttributeName:FONT_MAIN
                                            } forState:UIControlStateNormal];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)makeBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
{
    return [self makeBarButtonSystemItem:systemItem highlighted:NO];
}

+ (UIBarButtonItem *)makeBarButtonSystemItem:(UIBarButtonSystemItem)systemItem highlighted:(BOOL)highlighted
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:nil action:nil];
    
    if (highlighted) {
        barButtonItem.tintColor = COLOR_MAIN_HIGHLIGHT;
    } else {
        barButtonItem.tintColor = COLOR_MAIN_BLACK;
    }
    
    [barButtonItem setTitleTextAttributes:@{
                                            NSFontAttributeName:FONT_MAIN
                                            } forState:UIControlStateNormal];
    
    return barButtonItem;
}

+ (UIButton *)makeButton:(NSString *)title
{
    return [self makeButton:title font:FONT_MAIN];
}

+ (UIButton *)makeButton:(NSString *)title font:(UIFont *)font
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:3.0];
    button.titleLabel.font = font;
    button.titleLabel.backgroundColor = [UIColor clearColor];
    button.backgroundColor = COLOR_MAIN_BUTTON_BG;
    return button;
}

+ (UITextField *) makeTextField
{
    UITextField *textField = [[UITextField alloc] init];
    textField.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    textField.layer.cornerRadius = 3.0;
    
    //设置内左边距
    CGRect frame = [textField frame];
    frame.size.width = 7.0f;
    UIView *leftView = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    
    return textField;
}

@end
