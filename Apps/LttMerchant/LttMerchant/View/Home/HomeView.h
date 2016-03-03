//
//  HomeView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/2.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol HomeViewDelegate <NSObject>

- (void)actionCaseList;

- (void)actionStaff;

- (void)actionBusiness;

@end

@interface HomeView : AppView

@property (retain , nonatomic) id<HomeViewDelegate>delegate;

@end
