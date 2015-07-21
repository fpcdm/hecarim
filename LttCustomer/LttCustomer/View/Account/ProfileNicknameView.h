//
//  ProfileNicknameView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/18.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol ProfileNicknameViewDelegate <NSObject>

@required
- (void)actionSave:(NSString *)nickname;

@end

@interface ProfileNicknameView : AppView

@property (nonatomic, retain) id<ProfileNicknameViewDelegate> delegate;

@end
