//
//  GoodsListCell.m
//  LttMerchant
//
//  Created by wuyong on 15/8/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsListCell.h"
#import "DLRadioButton.h"

@interface GoodsListCell ()

@end

@implementation GoodsListCell
{
    BOOL isSelected;
}

//重载选中方法
- (BOOL) isSelected
{
    return isSelected ? YES : NO;
}

- (void) setSelected:(BOOL)selected
{
    isSelected = selected;
    
    //选中样式
    if (selected) {
        self.backgroundColor = COLOR_MAIN_SELECTED;
        $(@"#cellContainer").firstView.backgroundColor = COLOR_MAIN_SELECTED;
        
        DLRadioButton *radioButton = (DLRadioButton *) $(@"#checkboxButton").firstView;
        radioButton.selected = YES;
    } else {
        self.backgroundColor = COLOR_MAIN_WHITE;
        $(@"#cellContainer").firstView.backgroundColor = COLOR_MAIN_WHITE;
        
        DLRadioButton *radioButton = (DLRadioButton *) $(@"#checkboxButton").firstView;
        radioButton.selected = NO;
    }
}

- (void) unserialize:(id)obj
{
    [super unserialize:obj];
    
    if (obj) {
        NSNumber *editing = obj[@"editing"];
        if (editing && [@1 isEqualToNumber:editing]) {
            $(@"#priceLabel").ATTR(@"visibility", @"hidden");
            $(@"#numberLabel").ATTR(@"visibility", @"hidden");
            $(@"#checkboxButton").ATTR(@"visibility", @"visible");
            $(@"#numberContainer").ATTR(@"visibility", @"visible");
            
        } else {
            $(@"#priceLabel").ATTR(@"visibility", @"visible");
            $(@"#numberLabel").ATTR(@"visibility", @"visible");
            $(@"#checkboxButton").ATTR(@"visibility", @"hidden");
            $(@"#numberContainer").ATTR(@"visibility", @"hidden");
            
        }
    }
}

@end
