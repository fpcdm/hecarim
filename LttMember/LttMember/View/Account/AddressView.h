//
//  SafetyView.h
//  LttMember
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"
#import "AddressEntity.h"

@protocol AddressViewDelegate <NSObject>

@required

- (void)actionDetail:(AddressEntity *)address;

@end

@interface AddressView : AppTableView

@property (retain, nonatomic) id<AddressViewDelegate> delegate;

@end
