//
//  StorageUtil.m
//  LttCustomer
//
//  Created by wuyong on 15/5/1.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppStorageUtil.h"

@implementation StorageUtil (App)

- (void) setIntention: (NSNumber *) intentionId
{
    if (intentionId) {
        [[self storage] setObject:intentionId forKey:@"intention"];
        [[self storage] synchronize];
    
        NSLog(@"set intention: %@", intentionId);
    } else {
        [[self storage] removeObjectForKey:@"intention"];
        [[self storage] synchronize];
        
        NSLog(@"delete intention: %@", intentionId);
    }
}

- (NSNumber *) getIntention
{
    NSNumber *intentionId = (NSNumber *) [[self storage] objectForKey:@"intention"];
    if (!intentionId) {
        return nil;
    }
    
    NSLog(@"get intention: %@", intentionId);
    return intentionId;
}

@end
