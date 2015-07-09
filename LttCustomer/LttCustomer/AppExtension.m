//
//  StorageUtil.m
//  LttCustomer
//
//  Created by wuyong on 15/5/1.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppExtension.h"

//StorageUtil分类
@implementation StorageUtil (App)

- (void) setSmsTime: (NSDate *) time
{
    if (time) {
        [[self storage] setObject:time forKey:@"sms_time"];
        [[self storage] synchronize];
        
        NSLog(@"set sms time: %@", time);
    } else {
        [[self storage] removeObjectForKey:@"sms_time"];
        [[self storage] synchronize];
        
        NSLog(@"delete sms time");
    }
}

- (NSDate *) getSmsTime
{
    NSDate *time = (NSDate *) [[self storage] objectForKey:@"sms_time"];
    if (!time) {
        return nil;
    }
    
    NSLog(@"get sms time: %@", time);
    return time;
}

@end

//UserEntity分类
@implementation UserEntity (App)

- (UIImage *)avatarImage
{
    UIImage *image = nil;
    if (self.avatar && [[NSFileManager defaultManager] fileExistsAtPath:self.avatar]) {
        image = [UIImage imageWithContentsOfFile:self.avatar];
    } else {
        //返回默认头像
        image = [UIImage imageNamed:@"nopic"];
    }
    return image;
}

@end
