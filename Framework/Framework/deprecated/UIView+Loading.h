//
//  UIView+Loading.h
//  LttCustomer
//
//  Created by wuyong on 15/5/5.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Loading)

- (void) showLoading;

- (void) showLoading: (NSString *) message;

- (void) hideLoading;

- (void) showIndicator;

- (void) hideIndicator;

@end
