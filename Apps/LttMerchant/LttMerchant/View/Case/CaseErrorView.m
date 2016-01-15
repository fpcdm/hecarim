//
//  CaseErrorView.m
//  LttMerchant
//
//  Created by wuyong on 15/9/18.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CaseErrorView.h"

@implementation CaseErrorView

- (id) initWithMessage:(NSString *)message
{
    self = [super init];
    if (!self) return nil;
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.font = FONT_MAIN;
    messageLabel.textColor = COLOR_MAIN_BLACK;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    [self addSubview:messageLabel];
    
    UIView *superview = self;
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview.mas_centerX);
        make.centerY.equalTo(superview.mas_centerY);
    }];
 
    return self;
}

@end
