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

+ (void)sendMail:(NSString *)mail {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
}

+ (void)makePhoneCall:(NSString *)tel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

+ (void)sendSMS:(NSString *)tel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

+ (void)openURLWithSafari:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (NSString *)getNameFromAddressBookWithPhoneNum:(NSString *)tel{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)    {
    //       addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //        //等待同意后向下执行
    //        dispatch_semaphore_t sema = dispatch_semaphore_create(0);        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)                                                 {                                                     dispatch_semaphore_signal(sema);                                                 });
    //        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);         dispatch(sema);
    //    }else{
    //        addressBook = ABAddressBookCreate();
    //    }
    CFArrayRef records;
    if (addressBook) {
        // 获取通讯录中全部联系人
        records = ABAddressBookCopyArrayOfAllPeople(addressBook);
    }else{
        return nil;
    }
    // 遍历全部联系人，检查是否存在指定号码
    for (int i=0; i<CFArrayGetCount(records); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(records, i);
        CFTypeRef items = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFArrayRef phoneNums = ABMultiValueCopyArrayOfAllValues(items);
        if (phoneNums) {
            for (int j=0; j<CFArrayGetCount(phoneNums); j++) {
                NSString *phone = (NSString*)CFArrayGetValueAtIndex(phoneNums, j);
                phone = [self getOutOfTheNumber:phone];
                if ([phone isEqualToString:tel]) {
                    return (__bridge NSString*)ABRecordCopyCompositeName(record);
                }
            }
        }
    }
    return nil;
}

+(NSString *)getOutOfTheNumber:(NSString *)str{
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
