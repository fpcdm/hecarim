//
//  HomeView.m
//  LttMember
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeView.h"
#import "CategoryEntity.h"

@interface HomeView ()

@end

@implementation HomeView
{
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    return self;
}

#pragma mark - RenderData
- (void) renderData
{
    
}

- (void) actionCase: (UIButton *)sender
{
    
}

- (void)actionGps
{
    [self.delegate actionGps];
}

@end
