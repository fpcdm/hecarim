//
//  AccountView.h
//  LttMember
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol AccountViewDelegate <NSObject>

@required

- (void)actionContact:(NSString *)tel;

- (void)actionProfile;

- (void)actionLogout;

- (void)actionSafety;

- (void)actionAddress;

- (void)actionSuggestion;

@end

@interface AccountView : AppTableView

@property (retain, nonatomic) id<AccountViewDelegate> delegate;

@end
