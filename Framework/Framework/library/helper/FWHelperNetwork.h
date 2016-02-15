//
//  FWHelperNetwork.h
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FWHelperNetworkStatus) {
    FWHelperNetworkUnavailable = 0,
    FWHelperNetworkWwan = 1,
    FWHelperNetworkWifi = 2
};

@protocol FWHelperNetworkDelegate <NSObject>

@optional
- (void)networkChanged:(FWHelperNetworkStatus)status;

@end

@interface FWHelperNetwork : NSObject

@prop_strong(id<FWHelperNetworkDelegate>, delegate)

@singleton(FWHelperNetwork)

//获取网络状态
+ (FWHelperNetworkStatus)networkStatus;

//网络是否可用
+ (BOOL) networkAvailable;

//开始监听网络变化
- (void) startWatch;

//结束监听网络变化
- (void) endWatch;

@end
