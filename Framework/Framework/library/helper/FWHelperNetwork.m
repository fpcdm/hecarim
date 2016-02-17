//
//  FWHelperNetwork.m
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHelperNetwork.h"
#import "Reachability.h"

@implementation FWHelperNetwork
{
    Reachability *reachability;
}

//状态常量
@def_static_integer(UNAVAILABLE, 0)
@def_static_integer(WWAN, 1)
@def_static_integer(WIFI, 2)

@def_singleton(FWHelperNetwork)

+ (NSInteger)convertStatus:(NetworkStatus)status
{
    NSInteger result;
    switch (status) {
        //WIFI
        case ReachableViaWiFi:
            result = self.WIFI;
            break;
        //WWAN
        case ReachableViaWWAN:
            result = self.WWAN;
            break;
        //不能访问
        case NotReachable:
        default:
            result = self.UNAVAILABLE;
            break;
    }
    
    return result;
}

+ (NSInteger)networkStatus
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    return [self convertStatus:status];
}

+ (BOOL)networkAvailable
{
    return [self networkStatus] != self.UNAVAILABLE ? YES : NO;
}

//开始监听网络变化
- (void) startNotifier
{
    if (reachability) return;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    [self updateReachability:reachability];
}

//结束监听网络变化
- (void) endNotifier
{
    if (!reachability) return;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [reachability stopNotifier];
    reachability = nil;
}

//连接改变
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateReachability:curReach];
}

//处理连接改变后的情况
- (void) updateReachability: (Reachability *)curReach
{
    NetworkStatus status = [curReach currentReachabilityStatus];
    NSInteger result = [FWHelperNetwork convertStatus:status];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(networkChanged:)]) {
        [self.delegate networkChanged:result];
    }
}

- (void)dealloc
{
    [self endNotifier];
}

@end
