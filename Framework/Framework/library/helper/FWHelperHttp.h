//
//  FWHelperHttp.h
//  Framework
//
//  Created by wuyong on 16/2/17.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWHelperHttp : NSObject

@static_string(GET)

@static_string(POST)

+ (NSString *)queryString:(NSDictionary *)dict;

+ (NSString *)addParams:(NSString *)url params:(NSDictionary *)params;

+ (NSDictionary *)getParams:(NSString *)url;

+ (void)get:(NSString *)url params:(id)params callback:(void (^)(NSData *data, NSError *error))callback;

+ (void)post:(NSString *)url params:(id)params callback:(void (^)(NSData *data, NSError *error))callback;

+ (void)request:(NSString *)url params:(id)params headers:(NSDictionary *)headers method:(NSString *)method callback:(void (^)(NSData *data, NSError *error))callback;

@end
