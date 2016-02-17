//
//  FWHelperDevice.m
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHelperDevice.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation FWHelperDevice

+ (BOOL)playMusic:(NSString *)file
{
    // 参数是否正确
    if (!file) return NO;
    
    // 文件是否存在
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    if (soundFile && ![[NSFileManager defaultManager] fileExistsAtPath:soundFile]) {
        soundFile = nil;
    }
    
    // 播放内置声音
    if (soundFile) {
        NSURL *soundUrl = [NSURL fileURLWithPath:soundFile];
        SystemSoundID soundId = 0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &soundId);
        AudioServicesPlaySystemSound(soundId);
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)openUrl:(NSString *)url
{
    NSURL *nsurl = [NSURL URLWithString:url];
    if ([[UIApplication sharedApplication] canOpenURL:nsurl]) {
        [[UIApplication sharedApplication] openURL:nsurl];
        return YES;
    }
    return NO;
}

+ (BOOL)sendEmail:(NSString *)email
{
    return [self openUrl:[NSString stringWithFormat:@"mailto:%@", email]];
}

+ (BOOL)sendSms:(NSString *)phone
{
    return [self openUrl:[NSString stringWithFormat:@"sms://%@", phone]];
}

+ (BOOL)makePhoneCall:(NSString *)phone
{
    return [self openUrl:[NSString stringWithFormat:@"telprompt://%@", phone]];
}

+ (BOOL)openSafari:(NSString *)url
{
    return [self openUrl:url];
}

+ (BOOL)isJailbreak
{
    static const char * jbApps[] = {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    // method 1
    for ( int i = 0; jbApps[i]; ++i ) {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jbApps[i]]] ) {
            return YES;
        }
    }
    
    // method 2
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ) {
        return YES;
    }
    
    // method 3
    if ( 0 == system("ls") ) {
        return YES;
    }
    
    return NO;
}

@end