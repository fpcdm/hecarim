//
//  UIViewController+Framework.m
//  Framework
//
//  Created by wuyong on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UIViewController+Framework.h"
#import "FWPluginManager.h"

@implementation UIViewController (Framework)

- (id<FWPluginDialog>)dialogPlugin
{
    id plugin = [[FWPluginManager sharedInstance] getPlugin:FWPluginDialogName];
    return (id<FWPluginDialog>) plugin;
}

- (id<FWPluginLoading>)loadingPlugin
{
    id plugin = [[FWPluginManager sharedInstance] getPlugin:FWPluginLoadingName];
    return (id<FWPluginLoading>) plugin;
}

- (void)showLoading:(NSString *)message
{
    [[self loadingPlugin] showLoadingInViewController:self message:message];
}

- (void)finishLoading:(NSString *)message callback:(void (^)())callback
{
    [[self loadingPlugin] finishLoadingInViewController:self message:message callback:callback];
}

- (void)hideLoading
{
    [[self loadingPlugin] hideLoadingInViewController:self];
}

- (void)showDialog:(FWPluginDialogType)type message:(NSString *)message callback:(void (^)())callback
{
    [[self loadingPlugin] hideLoadingInViewController:self];
    [[self dialogPlugin] showDialogInViewController:self type:type message:message callback:callback];
}

- (void)showMessage:(NSString *)message callback:(void (^)())callback
{
    [self showDialog:FWPluginDialogTypeMessage message:message callback:callback];
}

- (void)showWarning:(NSString *)message callback:(void (^)())callback
{
    [self showDialog:FWPluginDialogTypeWarning message:message callback:callback];
}

- (void)showError:(NSString *)message callback:(void (^)())callback
{
    [self showDialog:FWPluginDialogTypeError message:message callback:callback];
}

- (void)showSuccess:(NSString *)message callback:(void (^)())callback
{
    [self showDialog:FWPluginDialogTypeSuccess message:message callback:callback];
}

- (void)showButton:(NSString *)message title:(NSString *)title callback:(void (^)())callback
{
    [[self loadingPlugin] hideLoadingInViewController:self];
    [[self dialogPlugin] showButtonInViewController:self message:message title:title callback:callback];
}

- (void)hideDialog
{
    [[self dialogPlugin] hideDialogInViewController:self];
}

- (void)sendSignal:(NSString *)name
{
    [self sendSignal:name withObject:nil];
}

- (void)sendSignal:(NSString *)name withObject:(NSObject *)object
{
    [self sendSignal:name withObject:object from:self];
}

- (void)sendSignal:(NSString *)name withObject:(NSObject *)object from:(id)source
{
    [self sendSignal:name withObject:object from:source to:self];
}

- (void)sendSignal:(NSString *)name withObject:(NSObject *)object to:(id)target
{
    [self sendSignal:name withObject:object from:self to:target];
}

- (void)sendSignal:(NSString *)name withObject:(NSObject *)object from:(id)source to:(id)target
{
    FWSignal *signal = [FWSignal signal];
    signal.source = source ? source : self;
    signal.target = target ? target : self;
    signal.name = name;
    signal.object = object;
    
    [signal send];
}

- (void)pushView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion
{
    if (animated) {
        [UIView animateWithDuration:0.1f
                         animations:^{
                             self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             self.view = view;
                             self.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                             [UIView animateWithDuration:0.2f
                                              animations:^{
                                                  self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  if (completion) completion();
                                              }
                              ];
                         }
         ];
    } else {
        self.view = view;
        if (completion) completion();
    }
}

- (void)popView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion
{
    if (animated) {
        [UIView animateWithDuration:0.1f
                         animations:^{
                             self.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             self.view = view;
                             self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                             [UIView animateWithDuration:0.2f
                                              animations:^{
                                                  self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  if (completion) completion();
                                              }
                              ];
                         }
         ];
    } else {
        self.view = view;
        if (completion) completion();
    }
}

@end

//来源：UIViewController+BackButtonHandler.m，感谢原作者
@interface UINavigationController (UIViewControllerFramework)

@end

@implementation UINavigationController (UIViewControllerFramework)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(shouldNavigationBarPopItem)]) {
        shouldPop = [vc shouldNavigationBarPopItem];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // Workaround for iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906
        for(UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    
    return NO;
}

@end
