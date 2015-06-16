//
//  AppUIUtil.h
//  LttCustomer
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AppViewController;

@interface AppUIUtil : NSObject

+ (UIBarButtonItem *) makeBarButtonItem: (NSString *) title;

+ (UIBarButtonItem *) makeBarButtonItem: (NSString *) title highlighted:(BOOL) highlighted;

+ (UIBarButtonItem *) makeBarButtonSystemItem: (UIBarButtonSystemItem) systemItem;

+ (UIBarButtonItem *) makeBarButtonSystemItem: (UIBarButtonSystemItem) systemItem highlighted:(BOOL) highlighted;

+ (UIButton *) makeButton: (NSString *) title;

@end
