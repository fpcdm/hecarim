//
//  BenchmarkUtil.h
//  LttMember
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BenchmarkUtil : NSObject

+ (BenchmarkUtil *) sharedInstance;

- (void) start:(NSString *)name;

- (void) end:(NSString *)name;

@end
