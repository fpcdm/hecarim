//
//  RegisterPasswordView.h
//  LttMember
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol RegisterPasswordViewDelegate <NSObject>

-(void)actionSendPassword:(NSString *)pwd confirmPwd:(NSString *)confirmPwd;

@end

@interface RegisterPasswordView : AppView

@property (retain, nonatomic) id<RegisterPasswordViewDelegate> delegate;

@end
