//
//  AddressFormViewController.h
//  LttAutoFInance
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppUserViewController.h"
#import "AddressEntity.h"

@interface AddressFormViewController : AppUserViewController

@property (retain, nonatomic) AddressEntity *address;

@property (retain, nonatomic) NSNumber *isDefault;

@end
