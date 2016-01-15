//
//  OrderNewView.h
//  LttMember
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseGoodsViewDelegate <NSObject>

- (void)actionPay;

@end

@interface CaseGoodsView : AppView

@property (retain,nonatomic) id<CaseGoodsViewDelegate> delegate;

@end
