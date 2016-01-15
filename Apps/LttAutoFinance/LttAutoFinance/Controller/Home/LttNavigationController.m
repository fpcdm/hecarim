//
//  LttNavigationController.m
//  LttMerchant
//
//  Created by wuyong on 15/4/27.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LttNavigationController.h"

@interface LttNavigationController ()

@property (strong, readwrite, nonatomic) MenuViewController *menuViewController;

@end

@implementation LttNavigationController
{
    BOOL menuEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuEnabled = YES;
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)showMenu
{
    if (menuEnabled) {
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        
        [self.frostedViewController presentMenuViewController];
    }
}

- (void) menuEnable:(BOOL)enable
{
    menuEnabled = enable;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    if (menuEnabled) {
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        
        [self.frostedViewController panGestureRecognized:sender];
    }
}

@end
