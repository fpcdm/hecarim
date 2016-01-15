//
//  BaseScrollView.m
//  LttMerchant
//
//  Created by wuyong on 15/11/13.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseScrollView.h"

@interface BaseScrollView ()

@end

@implementation BaseScrollView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //默认ScrollView
    self.scrollView = [self loadScrollView];
    if (self.scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.pagingEnabled = NO;
    }
    [self addSubview:self.scrollView];
    
    UIView *superview = self;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //内容视图
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.contentView];
    
    //自定义视图钩子，子类可以实现(不会影响别的子类)，也可以利用类分类实现(会影响别的子类)
    if ([self respondsToSelector:@selector(customScrollView)]) {
        [self performSelector:@selector(customScrollView)];
    }
    
    return self;
}

- (UIScrollView *)loadScrollView
{
    return nil;
}

- (void)setContentSize:(CGSize)contentSize
{
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, contentSize.width, contentSize.height);
    self.scrollView.contentSize = contentSize;
}

- (CGSize)contentSize
{
    return self.scrollView.contentSize;
}

@end
