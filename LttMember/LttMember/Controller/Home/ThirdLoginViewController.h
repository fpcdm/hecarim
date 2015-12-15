//
//  ThirdLoginViewController.h
//  LttMember
//
//  Created by wuyong on 15/6/9.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"
#import "UserEntity.h"

@interface ThirdLoginViewController : AppViewController

@property (retain, nonatomic) UserEntity *thirdUser;
@property (retain, nonatomic) NSDictionary *thirdParam;

@end
