//
//  DeviceUtil.m
//  Framework
//
//  Created by wuyong on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "DeviceUtil.h"
#import <AddressBook/AddressBook.h>

@implementation DeviceUtil

+ (BOOL)playMusic:(NSString *)file
{
    return [FWHelperDevice playMusic:file];
}

+ (BOOL)openUrl:(NSString *)url
{
    return [FWHelperDevice openUrl:url];
}

+ (BOOL)sendEmail:(NSString *)email
{
    return [FWHelperDevice sendEmail:email];
}

+ (BOOL)sendSms:(NSString *)phone
{
    return [FWHelperDevice sendSms:phone];
}

+ (BOOL)makePhoneCall:(NSString *)phone
{
    return [FWHelperDevice makePhoneCall:phone];
}

+ (BOOL)openSafari:(NSString *)url
{
    return [FWHelperDevice openSafari:url];
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
