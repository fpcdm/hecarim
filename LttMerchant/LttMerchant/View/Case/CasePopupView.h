//
//  CasePopupView.h
//  LttMember
//
//  Created by wuyong on 15/8/13.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol CasePopupViewDelegate <NSObject>

- (void)actionPopupMobile:(NSString *)mobile;
- (void)actionPopupClose;
- (void)actionPopupCompete:(NSNumber *)caseId;

@end

@interface CasePopupView : AppTableView

@property (retain,nonatomic) id<CasePopupViewDelegate> delegate;

- (void) startCompete;

- (void) finishCompete;

@end
