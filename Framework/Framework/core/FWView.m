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
    UIViewController *_viewController;
    
    NSMutableDictionary *viewData;
}

- (void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;
}

- (UIViewController *) viewController
{
    if (_viewController) return _viewController;
    
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
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
