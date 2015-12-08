//
//  ServicesContainer.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/25.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol ServicesContainerViewDelegate <NSObject>


@end

@interface ServicesContainerView : AppTableView

@property (retain , nonatomic) id<ServicesContainerViewDelegate>delegate;

@end
