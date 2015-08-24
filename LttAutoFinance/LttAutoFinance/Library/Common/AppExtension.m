//
//  StorageUtil.m
//  LttAutoFInance
//
//  Created by wuyong on 15/5/1.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppExtension.h"
#import "UIImageView+WebCache.h"

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

- (void) avatarView:(UIImageView *)view
{
    if (self.avatar && [self.avatar length] > 0) {
        NSLog(@"加载头像缓存：%@", self.avatar);
        [view sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"nopic"]];
    } else {
        view.image = [UIImage imageNamed:@"nopic"];
    }
}

@end
