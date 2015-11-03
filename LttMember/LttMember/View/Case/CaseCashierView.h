//
//  CaseCashierView.h
//  LttMember
//
//  Created by wuyong on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseCashierViewDelegate <NSObject>

@end

@interface CaseCashierView : AppView

@property (retain, nonatomic) id<CaseCashierViewDelegate> delegate;

@end
