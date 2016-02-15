//
//  FWViewController.m
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWViewController.h"

@interface FWViewController ()

@end

@implementation FWViewController
{
    NSString *_backBarTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解决导航栏覆盖view
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    //返回标题
    if (self.backBarTitle) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:self.backBarTitle style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
    }
}

- (NSString *)backBarTitle
{
    return _backBarTitle;
}

- (void)setBackBarTitle:(NSString *)backBarTitle
{
    _backBarTitle = backBarTitle;
}

@end
