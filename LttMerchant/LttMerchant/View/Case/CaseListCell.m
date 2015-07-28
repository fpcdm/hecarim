//
//  CaseListCellCollectionViewCell.m
//  LttMerchant
//
//  Created by wuyong on 15/7/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListCell.h"

@interface CaseListCell ()

@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation CaseListCell

- (void) unserialize:(id)obj
{
    [super unserialize:obj];
    
    if (obj) {
        //状态颜色
        UIColor *statusColor = obj[@"statusColor"];
        self.statusLabel.style.color = makeColor(statusColor);
        [self.statusLabel restyle];
    }
}

@end
