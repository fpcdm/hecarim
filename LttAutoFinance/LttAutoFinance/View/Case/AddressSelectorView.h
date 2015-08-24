//
//  SafetyView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"
#import "AddressEntity.h"

@protocol AddressSelectorViewDelegate <NSObject>

@required

- (void)actionSelected:(AddressEntity *)address;

@end

@interface AddressSelectorView : AppTableView

@property (retain, nonatomic) id<AddressSelectorViewDelegate> delegate;

@end
