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
@property (nonatomic, strong) UIButton *specButton;

@end

@implementation GoodsSpecCell
{
    NSMutableArray *buttons;
}

- (void) unserialize:(id)obj
{
    [super unserialize:obj];
    
    if (obj) {
        //移除之前的规格
        buttons = [[NSMutableArray alloc] init];
        for (UIView *view in _specList.subviews) {
            [view removeFromSuperview];
        }
        
        //添加规格按钮
        NSArray *children = obj[@"list"];
        NSInteger count = children ? [children count] : 0;
        if (count > 0) {
            CGFloat x = 0;
            CGFloat space = 5;
            for (SpecEntity *spec in children) {
                UIButton *button = [[UIButton alloc] init];
                button.titleLabel.font = FONT_MAIN;
                [button setTitle:spec.name forState:UIControlStateNormal];
                [button setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
                [button.titleLabel sizeToFit];
                
                button.layer.borderWidth = 0.5f;
                button.layer.borderColor = CGCOLOR_MAIN_BORDER;
                button.layer.cornerRadius = 3.0f;
                
                //根据文字宽度计算按钮宽度
                CGSize labelSize = button.titleLabel.frame.size;
                CGFloat width = (labelSize.width > 40 ? labelSize.width : 40) + 10;
                button.frame = CGRectMake(x, 2, width, 25);
                
                //添加specId数据绑定，先用tag绑定，后续可以考虑UIButton附加动态数据
                button.tag = [spec.id integerValue];
                
                //添加按钮事件
                [button addTarget:self action:@selector(actionSpec:) forControlEvents:UIControlEventTouchUpInside];
                
                [_specList addSubview:button];
                [buttons addObject:button];
                
                //按钮偏移
                x += width + space;
            }
        }
    }
}

- (void) actionSpec: (UIButton *) sender
{
    //取消其它所有选中
    for (UIButton *button in buttons) {
        button.backgroundColor = COLOR_MAIN_WHITE;
    }
    
    //选中当前并保存选中值
    sender.backgroundColor = COLOR_MAIN_HIGHLIGHT;
    NSString *value = [NSString stringWithFormat:@"%@", @(sender.tag)];
    _specButton.titleLabel.text = value;
    
    //触发规格改变事件（触发隐藏按钮事件实现更新主页面）
    [_specButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
