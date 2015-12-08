//
//  FrontendDom.h
//  LttMember
//
//  Created by wuyong on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FrontendDom : NSObject

@property (retain, nonatomic, readonly) UIView *view;

- (id)initWithView:(UIView *)view;

@end
