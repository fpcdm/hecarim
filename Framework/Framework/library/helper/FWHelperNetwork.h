//
//  FWHelperNetwork.h
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWHelperNetwork : NSObject

//改变通知
@notification(CHANGED)
@notification(CHANGED_UNAVAILABLE)
@notification(CHANGED_WIFI)
@notification(CHANGED_WLAN)

//状态常量
@static_integer(UNAVAILABLE)
@static_integer(WLAN)
@static_integer(WIFI)

@singleton(FWHelperNetwork)

//网络状态
@prop_readonly(NSInteger, status)

//网络是否可用
@prop_readonly(BOOL, isAvailable)

//本地IP
@prop_readonly(NSString *, localIp)

//开始监听网络变化
- (void) startNotifier;

//结束监听网络变化
- (void) endNotifier;

@end
