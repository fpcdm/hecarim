//
//  UIViewController+Javascript.h
//  Framework
//
//  Created by 吴勇 on 16/1/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWUrl.h"

@interface UIViewController (Javascript)

//设置URL，子类可重写
- (void)setURL:(FWUrl *)URL;

//获取URL，子类可重写
- (FWUrl *)URL;

@end
