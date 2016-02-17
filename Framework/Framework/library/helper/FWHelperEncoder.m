//
//  FWHelperCoder.m
//  Framework
//
//  Created by wuyong on 16/2/17.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHelperEncoder.h"
#import <CommonCrypto/CommonDigest.h>

@implementation FWHelperEncoder

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

+ (NSString *)urlEncodeComponent:(NSString *)str
{
    CFStringEncoding cfEncoding = kCFStringEncodingUTF8;
    str = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                       NULL,
                                                                       (CFStringRef)str,
                                                                       NULL,
                                                                       CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                       cfEncoding
                                                                       );
    return str;
}

+ (NSString *)urlDecodeComponent:(NSString *)str
{
    CFStringEncoding cfEncoding = kCFStringEncodingUTF8;
    str = (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding (
                                                                                        NULL,
                                                                                        (CFStringRef)str,
                                                                                        CFSTR(""),
                                                                                        cfEncoding
                                                                                        );
    return str;
}

+ (NSString *)urlEncode:(NSString *)str
{
    NSString *encUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger len = [encUrl length];
    const char *c;
    c = [encUrl UTF8String];
    NSString *ret = @"";
    for(int i = 0; i < len; i++) {
        switch (*c) {
            case '~':
                ret = [ret stringByAppendingString:@"%7E"];
                break;
            case '/':
                ret = [ret stringByAppendingString:@"%2F"];
                break;
            case '\'':
                ret = [ret stringByAppendingString:@"%27"];
                break;
            case ';':
                ret = [ret stringByAppendingString:@"%3B"];
                break;
            case '?':
                ret = [ret stringByAppendingString:@"%3F"];
                break;
            case ':':
                ret = [ret stringByAppendingString:@"%3A"];
                break;
            case '@':
                ret = [ret stringByAppendingString:@"%40"];
                break;
            case '&':
                ret = [ret stringByAppendingString:@"%26"];
                break;
            case '=':
                ret = [ret stringByAppendingString:@"%3D"];
                break;
            case '+':
                ret = [ret stringByAppendingString:@"%2B"];
                break;
            case '$':
                ret = [ret stringByAppendingString:@"%24"];
                break;
            case ',':
                ret = [ret stringByAppendingString:@"%2C"];
                break;
            case '[':
                ret = [ret stringByAppendingString:@"%5B"];
                break;
            case ']':
                ret = [ret stringByAppendingString:@"%5D"];
                break;
            case '#':
                ret = [ret stringByAppendingString:@"%23"];
                break;
            case '!':
                ret = [ret stringByAppendingString:@"%21"];
                break;
            case '(':
                ret = [ret stringByAppendingString:@"%28"];
                break;
            case ')':
                ret = [ret stringByAppendingString:@"%29"];
                break;
            case '*':
                ret = [ret stringByAppendingString:@"%2A"];
                break;
            default:
                ret = [ret stringByAppendingFormat:@"%c", *c];
        }
        c++;
    }
    
    return ret;
}

+ (NSString *)urlDecode:(NSString *)str
{
    //str = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
