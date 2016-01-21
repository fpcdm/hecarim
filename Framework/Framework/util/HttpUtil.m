//
//  HttpUtil.m
//  Framework
//
//  Created by wuyong on 16/1/20.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "HttpUtil.h"
#import "IKitUtil.h"

@implementation HttpUtil

+ (NSString *)getRootPath:(NSString *)path
{
    return [IKitUtil getRootPath:path];
}

+ (NSString *)getBasePath:(NSString *)path
{
    return [IKitUtil getBasePath:path];
}

+ (NSString *)joinPath:(NSString *)basePath path:(NSString *)path
{
    return [IKitUtil buildPath:basePath src:path];
}

+ (NSString *)urlEncode:(NSString *)str
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

+ (NSString *)urlDecode:(NSString *)str
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

+ (NSString *)queryString:(NSDictionary *)dict encoding:(BOOL)encoding
{
    NSMutableArray * pairs = [NSMutableArray array];
    for ( NSString * key in dict.allKeys )
    {
        NSString * value = [dict objectForKey:key];
        NSString * urlEncoding = encoding ? [self urlEncode:value] : value;
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)appendParam:(NSString *)url param:(NSDictionary *)param encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:url];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [self queryString:param encoding:encoding];
    return [NSString stringWithFormat:@"%@%@%@", url, queryPrefix, query];
}

+ (BOOL)isUrl:(NSString *)url
{
    if (!url) return NO;
    
    if([url rangeOfString:@"http://"].location == 0 || [url rangeOfString:@"https://"].location == 0){
        return YES;
    }
    return NO;
}

+ (BOOL)isHtml:(NSString *)str
{
    if ([str rangeOfString:@"</html>"].length > 0 || [str rangeOfString:@"</HTML>"].length > 0) {
        if ([str rangeOfString:@"</body>"].length > 0 || [str rangeOfString:@"</BODY>"].length > 0) {
            return YES;
        }
    }
    return NO;
}

+ (void)get:(NSString *)url params:(id)params callback:(HttpUtilCallback)callback
{
    [self request:url params:params headers:nil method:HttpUtilMethodGet callback:callback];
}

+ (void)post:(NSString *)url params:(id)params callback:(HttpUtilCallback)callback
{
    [self request:url params:params headers:nil method:HttpUtilMethodPost callback:callback];
}

+ (void)request:(NSString *)url params:(id)params headers:(NSDictionary *)headers method:(HttpUtilMethod)method callback:(HttpUtilCallback)callback
{
    NSMutableString *query = [[NSMutableString alloc] init];
    if (params && [params isKindOfClass: [NSString class]]) {
        query = params;
    } else if (params && [params isKindOfClass: [NSDictionary class]]) {
        NSUInteger n = [(NSDictionary *)params count];
        for (NSString *key in params) {
            NSString *val = [NSString stringWithFormat:@"%@", [params objectForKey:key]];
            [query appendString:[self urlEncode:key]];
            [query appendString:@"="];
            [query appendString:[self urlEncode:val]];
            if (--n > 0) {
                [query appendString:@"&"];
            }
        }
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:INTERVAL_HTTP_TIMEOUT];
    
    //添加Header
    if (headers) {
        for (NSString *key in headers) {
            [request addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    if (method == HttpUtilMethodPost) {
        NSData *reqData = [query dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:reqData];
        [request setHTTPMethod:@"POST"];
    } else {
        [request setHTTPMethod:@"GET"];
        if (query.length > 0) {
            if ([url rangeOfString:@"?"].location != NSNotFound) {
                url = [NSString stringWithFormat:@"%@&%@", url, query];
            } else {
                url = [NSString stringWithFormat:@"%@?%@", url, query];
            }
        }
    }
    
    [request setURL:[NSURL URLWithString:url]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *urlResp, NSData *data, NSError *error){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if(callback){
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)urlResp;
            NSInteger statusCode = httpResp.statusCode;
            //响应是否正确
            if (statusCode != 200 || error) data = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(data);
            });
        }
    }];
}

@end
