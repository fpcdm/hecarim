//
//  FWHelperNetwork.h
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

TODO("观察者模式")

@protocol FWHelperNetworkDelegate <NSObject>

@optional
- (void)networkChanged:(NSInteger)status;

@end

@interface FWHelperNetwork : NSObject

//状态常量
@static_integer(UNAVAILABLE)
@static_integer(WWAN)
@static_integer(WIFI)

@prop_strong(id<FWHelperNetworkDelegate>, delegate)

@singleton(FWHelperNetwork)

//获取网络状态
+ (NSInteger)networkStatus;

//网络是否可用
+ (BOOL) networkAvailable;

//开始监听网络变化
- (void) startNotifier;

//结束监听网络变化
- (void) endNotifier;

@end
