//
//  RechargeView.h
//  LttMember
//
//  Created by wuyong on 15/12/14.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol RechargeViewDelegate <NSObject>

- (void)actionRecharge:(NSString *)amount payWay:(NSString *)payWay;

@end

@interface RechargeView : AppTableView

@property (retain, nonatomic) id<RechargeViewDelegate> delegate;

@end
