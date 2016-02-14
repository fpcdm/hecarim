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

//单个赋值，暂不提供批量方法，防止参数为nil崩溃
- (void)assign:(NSString *)key value:(id)value;

//获取数据
- (id)fetch:(NSString *)key;

//展示数据，子类重写
- (void)display;

//展示单个数据，子类重写
- (void)render:(NSString *)key;

@end
