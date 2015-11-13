//
//  BaseScrollView.h
//  LttMerchant
//
//  Created by wuyong on 15/11/13.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseView.h"

@interface BaseScrollView : BaseView

@property (retain, nonatomic) UIScrollView *scrollView;

@property (retain, nonatomic) UIView *contentView;

@property (nonatomic) CGSize contentSize;

//加载主ScrollView
- (UIScrollView *)loadScrollView;

@end
