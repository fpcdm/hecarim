//
//  UIViewController+FIView.m
//  Framework
//
//  Created by wuyong on 16/2/17.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UIViewController+FIView.h"

@implementation UIViewController (FIView)

- (void)renderTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

- (void)renderMeta:(NSDictionary *)meta
{
    NSString *metaName = [meta objectForKey:@"name"];
    NSString *metaContent = [meta objectForKey:@"content"];
    if (!metaName || !metaContent) return;
    
    if ([metaName isEqualToString:@"navbar-bg-color"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithValue:metaContent];
    }
    if ([metaName isEqualToString:@"navbar-tint-color"]) {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithValue:metaContent];
    }
    if ([metaName isEqualToString:@"navbar-text-color"]) {
        NSDictionary *oldAttrs = self.navigationController.navigationBar.titleTextAttributes;
        NSMutableDictionary *attrs = oldAttrs ? [NSMutableDictionary dictionaryWithDictionary:oldAttrs] : [[NSMutableDictionary alloc] init];
        [attrs setObject:[UIColor colorWithValue:metaContent] forKey:NSForegroundColorAttributeName];
    }
    
    if ([metaName isEqualToString:@"navbar-hidden"]) {
        if ([metaContent isEqualToString:@"true"]) {
            self.navigationController.navigationBar.hidden = YES;
        } else {
            self.navigationController.navigationBar.hidden = NO;
        }
    }
    
    if ([metaName isEqualToString:@"statusbar-style"]) {
        if ([metaContent isEqualToString:@"light"]) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
    
    if ([metaName isEqualToString:@"navbar-left-item"] || [metaName isEqualToString:@"navbar-right-item"]) {
        NSString *metaOnclick = [meta objectForKey:@"onclick"];
        NSString *metaStyle = [meta objectForKey:@"style"];
        UIBarButtonItem *barItem = nil;
        SEL action = metaOnclick ? NSSelectorFromString(metaOnclick) : nil;
        if (action && ![self respondsToSelector:action]) {
            action = nil;
        }
        if (metaStyle && [metaStyle isEqualToString:@"image"]) {
            barItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:metaContent] style:UIBarButtonItemStylePlain target:self action:action];
        } else if (metaStyle && [metaStyle isEqualToString:@"system"]) {
            //todo: back
            static NSDictionary *systemStyles = nil;
            if (!systemStyles) {
                systemStyles = @{
                                 @"done": @(UIBarButtonSystemItemDone),
                                 @"cancel": @(UIBarButtonSystemItemCancel),
                                 @"edit": @(UIBarButtonSystemItemEdit),
                                 @"save": @(UIBarButtonSystemItemSave),
                                 @"add": @(UIBarButtonSystemItemAdd),
                                 //@"flexiblespace": @(UIBarButtonSystemItemFlexibleSpace),
                                 //@"fixedspace": @(UIBarButtonSystemItemFixedSpace),
                                 @"compose": @(UIBarButtonSystemItemCompose),
                                 @"reply": @(UIBarButtonSystemItemReply),
                                 @"action": @(UIBarButtonSystemItemAction),
                                 @"organize": @(UIBarButtonSystemItemOrganize),
                                 @"bookmarks": @(UIBarButtonSystemItemBookmarks),
                                 @"search": @(UIBarButtonSystemItemSearch),
                                 @"refresh": @(UIBarButtonSystemItemRefresh),
                                 @"stop": @(UIBarButtonSystemItemStop),
                                 @"camera": @(UIBarButtonSystemItemCamera),
                                 @"trash": @(UIBarButtonSystemItemTrash),
                                 @"play": @(UIBarButtonSystemItemPlay),
                                 @"pause": @(UIBarButtonSystemItemPause),
                                 @"rewind": @(UIBarButtonSystemItemRewind),
                                 @"fastforward": @(UIBarButtonSystemItemFastForward),
                                 @"undo": @(UIBarButtonSystemItemUndo),
                                 @"redo": @(UIBarButtonSystemItemRedo),
                                 //@"pagecurl": @(UIBarButtonSystemItemPageCurl),
                                 };
            }
            
            NSNumber *systemItem = [systemStyles objectForKey:metaContent];
            if (!systemItem) systemItem = @(UIBarButtonSystemItemDone);
            barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:[systemItem integerValue] target:self action:action];
        } else {
            barItem = [[UIBarButtonItem alloc] initWithTitle:metaContent style:UIBarButtonItemStylePlain target:self action:action];
        }
        
        if ([metaName isEqualToString:@"navbar-left-item"]) {
            self.navigationItem.leftBarButtonItem = barItem;
        } else {
            self.navigationItem.rightBarButtonItem = barItem;
        }
    }
}

@end
