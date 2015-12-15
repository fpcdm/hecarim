//
//  CaseCashierView.h
//  LttMember
//
//  Created by wuyong on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol CaseCashierViewDelegate <NSObject>

- (void)actionPayUseWay:(BOOL)useBalance payWay:(NSString *)payWay;

@end

@interface CaseCashierView : AppTableView

@property (retain, nonatomic) id<CaseCashierViewDelegate> delegate;

@end
