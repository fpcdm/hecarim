//
//  FrontendDom.m
//  LttMember
//
//  Created by wuyong on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "FrontendDom.h"

@implementation FrontendDom

@synthesize view;

- (id)initWithView:(UIView *)_view
{
    self = [super init];
    if (self) {
        view = _view;
    }
    return self;
}

@end
