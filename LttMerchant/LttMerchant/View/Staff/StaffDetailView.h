//
//  StaffDetailView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol StaffDetailViewDelegate <NSObject>

- (void)actionUploadAvatar;

- (void)actionRestPassword;

@end

@interface StaffDetailView : AppTableView

@property (retain, nonatomic) id<StaffDetailViewDelegate>delegate;

- (void)setUploadAvatar;

@end
