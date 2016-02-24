//
//  FWFramework.h
//  Framework
//
//  Created by wuyong on 16/2/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFramework : NSObject

@singleton(FWFramework)

//自动启动，无需调用
- (void)startup;

@end
