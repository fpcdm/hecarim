//
//  FWUrl.m
//  Framework
//
//  Created by 吴勇 on 16/1/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWUrl.h"

@implementation FWUrl

@synthesize path;

@synthesize query;

@synthesize fragment;

+ (id)urlWithString:(NSString *)url
{
    return [[self alloc] initWithString:url];
}

+ (id)urlWithPath:(NSString *)path query:(NSDictionary *)query fragment:(NSString *)fragment
{
    return [[self alloc] initWithPath:path query:query fragment:fragment];
}

- (id)init
{
    return [self initWithString:nil];
}

- (id)initWithString:(NSString *)url
{
    NSString *_path = nil;
    NSDictionary *_query = nil;
    NSString *_fragment = nil;
    
    //解析url
    if (url) {
        NSArray *urlParts = [url componentsSeparatedByString:@"?"];
        
        //解析path
        NSString *pathPart = [urlParts objectAtIndex:0];
        if (pathPart && [pathPart length] > 0) {
            _path = pathPart;
        }
        
        //解析query
        NSString *queryPart = [urlParts count] > 1 ? [urlParts objectAtIndex:1] : nil;
        if (queryPart && [queryPart length] > 0) {
            urlParts = [queryPart componentsSeparatedByString:@"#"];
            queryPart = [urlParts objectAtIndex:0];
            if (queryPart && [queryPart length] > 0) {
                //解析&
                NSMutableDictionary *queryDict = [[NSMutableDictionary alloc] init];
                NSArray *dictParts = [queryPart componentsSeparatedByString:@"&"];
                NSArray *paramArray = nil;
                NSString *paramKey = nil;
                NSString *paramValue = nil;
                
                //解析=
                for (NSString *dictPart in dictParts) {
                    paramArray = [dictPart componentsSeparatedByString:@"="];
                    paramKey = [paramArray objectAtIndex:0];
                    if (paramKey && [paramKey length] > 0) {
                        paramValue = [paramArray count] > 1 ? [paramArray objectAtIndex:1] : @"";
                        [queryDict setObject:paramValue forKey:paramKey];
                    }
                }
                
                _query = [NSDictionary dictionaryWithDictionary:queryDict];
            }
            
            //解析fragment
            NSString *fragmentPart = [urlParts count] > 1 ? [urlParts objectAtIndex:1] : nil;
            if (fragmentPart && [fragmentPart length] > 0) {
                _fragment = fragmentPart;
            }
        }
    }
    
    return [self initWithPath:_path query:_query fragment:_fragment];
}

- (id)initWithPath:(NSString *)_path query:(NSDictionary *)_query fragment:(NSString *)_fragment
{
    self = [super init];
    if (self) {
        path = _path;
        query = _query;
        fragment = _fragment;
    }
    return self;
}

@end
