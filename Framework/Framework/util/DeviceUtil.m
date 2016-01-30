//
//  DeviceUtil.m
//  Framework
//
//  Created by wuyong on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "DeviceUtil.h"
#import <AddressBook/AddressBook.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation DeviceUtil

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

+ (NSString *)getPhoneName:(NSString *)phone
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef records;
    if (addressBook) {
        //获取通讯录中全部联系人
        records = ABAddressBookCopyArrayOfAllPeople(addressBook);
    } else {
        return nil;
    }
    
    // 遍历全部联系人，检查是否存在指定号码
    for (int i = 0; i < CFArrayGetCount(records); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(records, i);
        CFTypeRef items = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFArrayRef phoneNums = ABMultiValueCopyArrayOfAllValues(items);
        if (phoneNums) {
            for (int j = 0; j < CFArrayGetCount(phoneNums); j++) {
                NSString *tel = (NSString*)CFArrayGetValueAtIndex(phoneNums, j);
                tel = [self filterPhoneNumber:tel];
                if ([tel isEqualToString:phone]) {
                    return (__bridge NSString*)ABRecordCopyCompositeName(record);
                }
            }
        }
    }
    return nil;
}

+ (NSString *)filterPhoneNumber:(NSString *)str
{
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:str.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        }
        else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return strippedString;
}

@end
