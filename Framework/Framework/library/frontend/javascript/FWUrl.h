//
//  FWUrl.h
//  Framework
//
//  Created by 吴勇 on 16/1/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWUrl : NSObject

@property (retain, nonatomic) NSString *path;

@property (retain, nonatomic) NSDictionary *query;

@property (retain, nonatomic) NSString *fragment;

+ (id)urlWithString:(NSString *)url;

+ (id)urlWithPath:(NSString *)path query:(NSDictionary *)query fragment:(NSString *)fragment;

- (id)initWithString:(NSString *)url;

- (id)initWithPath:(NSString *)path query:(NSDictionary *)query fragment:(NSString *)fragment;

@end
