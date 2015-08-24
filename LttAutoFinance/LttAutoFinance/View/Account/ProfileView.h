//
//  ProfileView.h
//  LttAutoFInance
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol ProfileViewDelegate <NSObject>

- (void)actionSex;

- (void)actionNickname;

- (void)actionAvatar;

@end

@interface ProfileView : AppTableView

@property (retain, nonatomic) id<ProfileViewDelegate> delegate;

@end
