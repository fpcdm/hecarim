//
//  FWView.m
//  Framework
//
//  Created by 吴勇 on 16/2/14.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWView.h"

@implementation FWView
{
    NSMutableDictionary *viewData;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

//init会自动调用initWithFrame:CGRectZero
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    //子类重写
}

- (void)assign:(NSString *)key value:(id)value
{
    if (value == nil) return;
    if (!viewData) viewData = [[NSMutableDictionary alloc] init];
    
    [viewData setObject:value forKey:key];
}

- (void)assign:(NSDictionary *)data
{
    if (data == nil) return;
    if (!viewData) viewData = [[NSMutableDictionary alloc] init];
    
    [viewData addEntriesFromDictionary:data];
}

- (id)fetch:(NSString *)key
{
    return viewData ? [viewData objectForKey:key] : nil;
}

- (NSDictionary *)fetchAll
{
    return viewData ? viewData : nil;
}

- (void)display
{
    //子类重写
}

- (void)render:(NSString *)key
{
    //子类重写
}

@end
