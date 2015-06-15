//
//  SafetyView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol AddressViewDelegate <NSObject>

@end

@interface AddressView : AppTableView

@property (retain, nonatomic) id<AddressViewDelegate> delegate;

@end
