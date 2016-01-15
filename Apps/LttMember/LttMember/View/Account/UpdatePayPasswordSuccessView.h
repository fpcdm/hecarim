//
//  UpdatePayPasswordSuccessView.h
//  LttMember
//
//  Created by 杨海锋 on 15/12/9.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol UpdatePayPasswordSuccessViewDelegate <NSObject>

- (void)actionGoSafe;

@end

@interface UpdatePayPasswordSuccessView : AppView

@property (retain , nonatomic) id<UpdatePayPasswordSuccessViewDelegate>delegate;

@end
