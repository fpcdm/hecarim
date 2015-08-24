//
//  AddressDetailViewController.h
//  LttAutoFInance
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppUserViewController.h"
#import "AddressEntity.h"

@interface AddressDetailViewController : AppUserViewController

@property (retain, nonatomic) AddressEntity *address;

@property (copy) CallbackBlock deleteBlock;

@property (copy) CallbackBlock defaultBlock;

@end
