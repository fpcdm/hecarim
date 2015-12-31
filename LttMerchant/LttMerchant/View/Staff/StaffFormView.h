//
//  StaffFormView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppScrollView.h"
#import "StaffEntity.h"

@protocol StaffFormViewDelegate <NSObject>

- (void)actionSave:(StaffEntity *)staff;

@end

@interface StaffFormView : AppScrollView

@property (retain, nonatomic) id<StaffFormViewDelegate>delegate;

@end
