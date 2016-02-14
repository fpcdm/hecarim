//
//  StringUtil.m
//  Framework
//
//  Created by wuyong on 16/1/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "EncodeUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation EncodeUtil

+ (NSString *)jsonEncode:(id)obj
{
    if([obj isKindOfClass:[NSString class]]){
        NSString *s = obj;
        s = [s stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        s = [s stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
        s = [s stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        s = [s stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
        s = [s stringByReplacingOccurrencesOfString:@"\b" withString:@"\\b"];
        return [NSString stringWithFormat:@"\"%@\"", s];
    }
    BOOL is_primative = false;
    if(![obj isKindOfClass:[NSArray class]] && ![obj isKindOfClass:[NSDictionary class]]){
        is_primative = true;
        obj = [NSArray arrayWithObject: obj];
    }
    id data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    NSError *err = nil;
    NSString *str = [[NSString alloc] initWithData:data encoding:[NSString defaultCStringEncoding]];
    if(err){
        NSLog(@"error for: %@", obj);
        return nil;
    }
    if(is_primative){
        str = [str substringWithRange:NSMakeRange(1, [str length]-2)];
    }
    return str;
}

+ (id)jsonDecode:(NSString *)str
{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    if(!data){
        return nil;
    }
    NSError *err = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    if(err){
        return nil;
    }
    return obj;
}

+ (NSString *)base64Encode:(NSString *)str
{
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    if(!data){
        return nil;
    }
    return [self base64EncodeData:data];
}

+ (NSString *)base64Decode:(NSString *)str
{
    NSData *data = [self base64DecodeData:str];
    if (!data) {
        return nil;
    }
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSString *)base64EncodeData:(NSData *)data
{
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSData *)base64DecodeData:(NSString *)str
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
