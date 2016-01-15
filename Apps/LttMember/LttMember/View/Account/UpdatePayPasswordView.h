//
//  UpdatePayPasswordView.h
//  LttMember
//
//  Created by 杨海锋 on 15/12/9.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol UpdatePayPasswordViewDelegate <NSObject>

- (void)actionNext:(NSString *)oldPassword newPassword:(NSString *)newPassword;

@end

@interface UpdatePayPasswordView : AppView

@property (retain , nonatomic) id<UpdatePayPasswordViewDelegate>delegate;

@end
