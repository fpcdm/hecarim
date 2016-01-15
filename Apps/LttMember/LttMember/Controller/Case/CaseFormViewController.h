//
//  CaseFormViewController.h
//  LttMember
//
//  Created by wuyong on 15/7/14.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppUserViewController.h"
#import "CaseEntity.h"
#import "AddressEntity.h"

@interface CaseFormViewController : AppUserViewController

@property (nonatomic, retain) CaseEntity *caseEntity;

//当前定位城市
@property (nonatomic, retain) AddressEntity *currentAddress;

@end
