//
//  CaseConsumeCell.m
//  LttMerchant
//
//  Created by wuyong on 15/9/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseTableCell.h"

@implementation CaseTableCell

- (void) unserialize:(id)obj
{
    [super unserialize:obj];
    
    if (obj) {
        NSNumber *accessoryType = obj[@"accessoryType"];
        if (accessoryType) {
            self.accessoryType = [accessoryType integerValue];
        }
    }
}

@end
