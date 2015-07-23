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
@property (nonatomic, strong) UIButton *competeButton;

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
        
        //显示按钮
        NSString *status = obj[@"status"];
        if (status && [CASE_STATUS_NEW isEqualToString:status]) {
            [self.competeButton style_removeClass:@"hide"];
            [self.competeButton restyle];
        } else {
            [self.competeButton style_addClass:@"hide"];
            [self.competeButton restyle];
        }
    }
}

@end
