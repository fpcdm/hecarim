//
//  SafetyView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressView.h"
#import "AddressEntity.h"

@implementation AddressView
{
    NSMutableArray *addressList;
}

#pragma mark - RenderData
- (void)renderData
{
    addressList = [self getData:@"addressList"];
    if (addressList == nil) {
        addressList = [[NSMutableArray alloc] initWithObjects: nil];
    }
    
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    for (AddressEntity *address in addressList) {
        [tableData addObject:@{
                               @"id": @"",
                               @"type": @"custom",
                               @"action": @"",
                               }];
    }
}

@end
