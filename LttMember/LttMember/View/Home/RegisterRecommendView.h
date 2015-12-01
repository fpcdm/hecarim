//
//  RegisterRecommendView.h
//  LttMember
//
//  Created by 杨海锋 on 15/12/1.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol RegisterRecommendViewDelegate <NSObject>

- (void)actionRecommend:(NSString *)recommendMobile;

@end

@interface RegisterRecommendView : AppView

@property (retain , nonatomic) id<RegisterRecommendViewDelegate>delegate;

- (void)hideKeyboard;

@end
