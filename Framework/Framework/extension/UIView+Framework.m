//
//  UIView+Framework.m
//  Framework
//
//  Created by wuyong on 16/1/28.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UIView+Framework.h"
#import "Masonry.h"

@implementation UIView (Framework)

- (void) showIndicator
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.tag = -1;
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicator.backgroundColor = [UIColor clearColor];
    indicator.layer.cornerRadius = 3;
    indicator.layer.masksToBounds = YES;
    [self addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [indicator startAnimating];
}

- (void) hideIndicator
{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIActivityIndicatorView class]] &&
            subview.tag == -1) {
            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)subview;
            [indicator stopAnimating];
            [indicator removeFromSuperview];
        }
    }
}

@end