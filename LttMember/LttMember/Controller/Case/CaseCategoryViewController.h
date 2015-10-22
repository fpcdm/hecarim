//
//  CaseCategoryViewController.h
//  LttMember
//
//  Created by wuyong on 15/10/22.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppUserViewController.h"

@interface CaseCategoryViewController : AppUserViewController

//分类Id为空时选择场景，否则选择类型
@property (retain, nonatomic) NSNumber *categoryId;

@end
