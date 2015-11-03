//
//  CaseCashierView.h
//  LttMember
//
//  Created by wuyong on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseCashierViewDelegate <NSObject>

- (void)actionWeixinQrcode;
- (void)actionAlipayQrcode;
- (void)actionUseMoney;

@end

@interface CaseCashierView : AppView

@property (retain, nonatomic) id<CaseCashierViewDelegate> delegate;

@end
