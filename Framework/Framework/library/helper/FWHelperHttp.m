//
//  FWHelperHttp.m
//  Framework
//
//  Created by wuyong on 16/2/17.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHelperHttp.h"
#import "IKitUtil.h"
#import "FWHelperEncoder.h"

@implementation FWHelperHttp

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

+ (NSString *)queryString:(NSDictionary *)dict
{
    NSMutableArray * pairs = [NSMutableArray array];
    for ( NSString * key in dict.allKeys )
    {
        NSString * value = [dict objectForKey:key];
        NSString * urlEncoding = [FWHelperEncoder urlEncodeComponent:value];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)addParams:(NSString *)url params:(NSDictionary *)params
{
    NSURL * parsedURL = [NSURL URLWithString:url];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [self queryString:params];
    return [NSString stringWithFormat:@"%@%@%@", url, queryPrefix, query];
}

+ (NSDictionary *)getParams:(NSString *)url
{
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    if (NSNotFound != [url rangeOfString:@"?"].location) {
        NSString *paramString = [url substringFromIndex:
                                 ([url rangeOfString:@"?"].location + 1)];
        NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
        NSScanner* scanner = [[NSScanner alloc] initWithString:paramString];
        while (![scanner isAtEnd]) {
            NSString* pairString = nil;
            [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
            if (kvPair.count == 2) {
                NSString* key = [FWHelperEncoder urlDecodeComponent:[kvPair objectAtIndex:0]];
                NSString* value = [FWHelperEncoder urlDecodeComponent:[kvPair objectAtIndex:1]];
                [pairs setValue:value forKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
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

+ (void)get:(NSString *)url params:(id)params callback:(void (^)(NSData *data, NSError *error))callback
{
    [self request:url params:params headers:nil method:FWHelperHttpMethodGet callback:callback];
}

+ (void)post:(NSString *)url params:(id)params callback:(void (^)(NSData *data, NSError *error))callback
{
    [self request:url params:params headers:nil method:FWHelperHttpMethodPost callback:callback];
}

+ (void)request:(NSString *)url params:(id)params headers:(NSDictionary *)headers method:(FWHelperHttpMethod)method callback:(void (^)(NSData *data, NSError *error))callback
{
    NSMutableString *query = [[NSMutableString alloc] init];
    if (params && [params isKindOfClass: [NSString class]]) {
        query = params;
    } else if (params && [params isKindOfClass: [NSDictionary class]]) {
        NSUInteger n = [(NSDictionary *)params count];
        for (NSString *key in params) {
            NSString *val = [NSString stringWithFormat:@"%@", [params objectForKey:key]];
            [query appendString:[FWHelperEncoder urlEncodeComponent:key]];
            [query appendString:@"="];
            [query appendString:[FWHelperEncoder urlEncodeComponent:val]];
            if (--n > 0) {
                [query appendString:@"&"];
            }
        }
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:FRAMEWORK_TIMEINTERVAL_REQUEST];
    
    //添加Header
    if (headers) {
        for (NSString *key in headers) {
            [request addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    if (method == FWHelperHttpMethodPost) {
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
                callback(data, error);
            });
        }
    }];
}

@end
