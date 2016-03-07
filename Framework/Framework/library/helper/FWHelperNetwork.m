//
//  FWHelperNetwork.m
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHelperNetwork.h"
#import "Reachability.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

@implementation FWHelperNetwork
{
    Reachability *reachability;
    BOOL notifierStarted;
}

//改变通知
@def_notification(CHANGED)
@def_notification(CHANGED_UNAVAILABLE)
@def_notification(CHANGED_WIFI)
@def_notification(CHANGED_WLAN)

//状态常量
@def_static_integer(UNAVAILABLE, 0)
@def_static_integer(WLAN, 1)
@def_static_integer(WIFI, 2)

@def_singleton(FWHelperNetwork)

@def_prop_dynamic(NSInteger, status)
@def_prop_dynamic(BOOL, isAvailable)
@def_prop_dynamic(NSString *, hostname)
@def_prop_dynamic(NSString *, localIp)

- (instancetype)init
{
    self = [super init];
    if (self) {
        reachability = [Reachability reachabilityForInternetConnection];
    }
    return self;
}

- (NSInteger)status
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    return [self convertStatus:status];
}

- (BOOL)isAvailable
{
    return self.status != self.UNAVAILABLE ? YES : NO;
}

- (NSString *)hostname
{
    char baseHostName[256];
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '/0';
    
#if TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s", baseHostName];
#else
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}

- (NSString *)localIp
{
    NSString *ipAddr = nil;
    struct ifaddrs *addrs = NULL;
    
    int ret = getifaddrs(&addrs);
    if (0 == ret) {
        const struct ifaddrs * cursor = addrs;
        
        while (cursor) {
            if (AF_INET == cursor->ifa_addr->sa_family && 0 == (cursor->ifa_flags & IFF_LOOPBACK)) {
                ipAddr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                break;
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return ipAddr;
}

//转换状态
- (NSInteger)convertStatus:(NetworkStatus)status
{
    NSInteger result;
    switch (status) {
        //WIFI
        case ReachableViaWiFi:
            result = self.WIFI;
            break;
        //WWAN
        case ReachableViaWWAN:
            result = self.WLAN;
            break;
        //不能访问
        case NotReachable:
        default:
            result = self.UNAVAILABLE;
            break;
    }
    
    return result;
}

//开始监听网络变化
- (void) startNotifier
{
    if (notifierStarted) return;
    notifierStarted = YES;
    
    [self observeNotification:kReachabilityChangedNotification];
    [reachability startNotifier];
}

//结束监听网络变化
- (void) stopNotifier
{
    if (!notifierStarted) return;
    notifierStarted = NO;
    
    [self unobserveAllNotifications];
    [reachability stopNotifier];
}

- (void)dealloc
{
    [self stopNotifier];
    reachability = nil;
}

//处理连接改变后的情况
handleNotification()
{
    if (![notification isName:kReachabilityChangedNotification]) return;
    
    NSInteger status = self.status;
    if (status == self.UNAVAILABLE) {
        [self postNotification:self.CHANGED_UNAVAILABLE];
    } else if (status == self.WIFI) {
        [self postNotification:self.CHANGED_WIFI];
    } else {
        [self postNotification:self.CHANGED_WLAN];
    }
    
    [self postNotification:self.CHANGED];
}

@end
