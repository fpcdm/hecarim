//
//  BusinessDetailView.h
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "AppScrollView.h"
#import "BusinessEntity.h"

@protocol BusinessDetailViewDelegate <NSObject>

- (void)deleteBusiness:(BusinessEntity *)business;

@end

@interface BusinessDetailView : AppScrollView

@property (retain, nonatomic) id<BusinessDetailViewDelegate>delegate;

@end
