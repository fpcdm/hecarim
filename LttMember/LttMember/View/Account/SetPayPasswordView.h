//
//  SetPayPasswordView.h
//  LttMember
//
//  Created by 杨海锋 on 15/12/9.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol SetPayPasswordViewDelegate <NSObject>

- (void)actionSetPayPassword:(NSString *)password rePassword:(NSString *)rePassword;

@end

@interface SetPayPasswordView : AppView

@property (retain , nonatomic) id<SetPayPasswordViewDelegate>delegate;

@end
