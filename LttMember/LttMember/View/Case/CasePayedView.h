//
//  CasePayedView.h
//  LttMember
//
//  Created by wuyong on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CasePayedViewDelegate <NSObject>

- (void)actionConfirmPayed;
- (void)actionRechooseMethod;

@end

@interface CasePayedView : AppView

@property (retain, nonatomic) id<CasePayedViewDelegate> delegate;

@end
