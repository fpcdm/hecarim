//
//  FWPresenter.h
//  Framework
//
//  Created by wuyong on 16/1/28.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//持有View对象(主要是调用View协议更新数据)和Model对象（Model不传递给View，数据转换后调用View协议）
@interface FWPresenter : NSObject

//持有view
//持有model
//控制器ViewController持有presenter,presenter和视图打交道

@end
