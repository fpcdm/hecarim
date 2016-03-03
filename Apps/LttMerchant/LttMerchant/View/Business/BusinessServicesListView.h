//
//  BusinessServicesListView.h
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol BusinessServicesListViewDelegate <NSObject>

- (void)actionSelectServices:(NSDictionary *)services;

@end

@interface BusinessServicesListView : AppTableView

@property (retain, nonatomic) id<BusinessServicesListViewDelegate>delegate;

@end
