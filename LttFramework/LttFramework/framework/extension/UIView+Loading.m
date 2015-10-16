//
//  UIView+Loading.m
//  LttCustomer
//
//  Created by wuyong on 15/5/5.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "UIView+Loading.h"
#import "MBProgressHUD.h"
#import "FrameworkConfig.h"
#import "Masonry.h"

@implementation UIView (Loading)

- (void) showLoading
{
    [self showLoading: MESSAGE_VIEW_LOADING];
}

- (void) showLoading: (NSString *) message
{
    MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:self animated:YES];
    loading.labelText = message;
}

- (void) hideLoading
{
    [MBProgressHUD hideHUDForView:self animated:NO];
}

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
