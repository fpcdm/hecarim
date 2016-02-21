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

- (UIViewController *) viewController
{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (void)sendSignal:(NSString *)name
{
    [self sendSignal:name withObject:nil];
}

- (void)sendSignal:(NSString *)name withObject:(NSObject *)object
{
    [self sendSignal:name withObject:object from:self];
}

- (void)sendSignal:(NSString *)name withObject:(NSObject *)object from:(id)source
{
    [self sendSignal:name withObject:object from:source to:self];
}

- (void)sendSignal:(NSString *)name withObject:(NSObject *)object to:(id)target
{
    [self sendSignal:name withObject:object from:self to:target];
}

- (void)sendSignal:(NSString *)name withObject:(NSObject *)object from:(id)source to:(id)target
{
    FWSignal *signal = [FWSignal signal];
    signal.source = source ? source : self;
    signal.target = target ? target : self;
    signal.name = name;
    signal.object = object;
    
    [signal send];
}

@end
