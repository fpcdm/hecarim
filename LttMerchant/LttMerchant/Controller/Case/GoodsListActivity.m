//
//  GoodsListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsListActivity.h"
#import "GoodsFormActivity.h"

@interface GoodsListActivity ()

@end

@implementation GoodsListActivity

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
}

- (NSString *)templateName
{
    return @"goodsList.html";
}

#pragma mark - Action
- (void) actionAddGoods: (SamuraiSignal *) signal
{
    GoodsFormActivity *activity = [[GoodsFormActivity alloc] init];
    activity.caseId = self.caseId;
    [self pushViewController:activity animated:YES];
}

@end
