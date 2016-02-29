//
//  FWView.h
//  Framework
//
//  Created by 吴勇 on 16/2/14.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface FWView : UIView

//初始化钩子方法

//设置当前控制器
- (void) setViewController:(UIViewController *)viewController;

//获取当前控制器
- (UIViewController *) viewController;

//单个赋值，建议使用此方法赋值，防止参数为nil崩溃
- (void)assign:(NSString *)key value:(id)value;

//批量赋值，注意字典不能有nil值，否则会引起崩溃
- (void)assign:(NSDictionary *)data;

//获取单个数据
- (id)fetch:(NSString *)key;

//获取所有数据
- (NSDictionary *)fetchAll;

//展示数据，子类重写
- (void)display;

//展示单个数据，子类重写
- (void)render:(NSString *)key;

@end
