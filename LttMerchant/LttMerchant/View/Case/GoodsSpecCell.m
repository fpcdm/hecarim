//
//  GoodsSpecCell.m
//  LttMerchant
//
//  Created by wuyong on 15/8/5.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsSpecCell.h"
#import "SpecEntity.h"

@interface GoodsSpecCell ()

@property (nonatomic, strong) UIView *specList;

@end

@implementation GoodsSpecCell

- (void) unserialize:(id)obj
{
    [super unserialize:obj];
    
    if (obj) {
        //移除之前的规格
        for (UIView *view in _specList.subviews) {
            [view removeFromSuperview];
        }
        
        //添加规格按钮
        NSArray *children = obj[@"list"];
        NSInteger count = children ? [children count] : 0;
        if (count > 0) {
            CGFloat x = 0;
            CGFloat width = 55;
            CGFloat space = 5;
            for (SpecEntity *spec in children) {
                UIButton *button = [[UIButton alloc] init];
                button.titleLabel.font = FONT_MIDDLE;
                button.frame = CGRectMake(x, 0, width, 20);
                button.layer.borderWidth = 0.5f;
                button.layer.borderColor = CGCOLOR_MAIN_BORDER;
                button.layer.cornerRadius = 3.0f;
                [button setTitle:spec.name forState:UIControlStateNormal];
                [button setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
                
                //添加specId数据绑定，先用tag绑定，后续可以考虑UIButton附加动态数据
                button.tag = [spec.id integerValue];
                
                [_specList addSubview:button];
                
                //按钮偏移
                x += width + space;
            }
        }
    }
}

@end
