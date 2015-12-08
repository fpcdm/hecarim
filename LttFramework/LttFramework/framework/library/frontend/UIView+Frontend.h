//
//  UIView+Frontend.h
//  LttMember
//
//  Created by wuyong on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontendDom.h"
#import "FrontendCss.h"

@interface UIView (Frontend)

@property (retain, nonatomic, readonly) FrontendDom *dom;

@property (retain, nonatomic, readonly) FrontendCss *css;

@end
