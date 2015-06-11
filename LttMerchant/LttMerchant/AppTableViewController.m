//
//  BaseTableViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableViewController.h"
#import "LttNavigationController.h"

@interface AppTableViewController ()

@end

@implementation AppTableViewController

@synthesize tableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //禁用菜单
    if (isMenuDisabled) {
        //禁用手势
        [(LttNavigationController *) self.navigationController menuEnable:NO];
        
        self.navigationItem.leftBarButtonItem = nil;
        //左侧为返回
    } else if (isMenuBack) {
        //禁用手势
        [(LttNavigationController *) self.navigationController menuEnable:NO];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        //显示菜单
    } else {
        //启用手势
        [(LttNavigationController *) self.navigationController menuEnable:YES];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:(LttNavigationController *)self.navigationController
                                                                                action:@selector(showMenu)];
    }
    
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    self.tableView.tableFooterView = tableFooterView;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) showEmpty:(NSString *)message
{
    //空数据
    if ([tableData count] < 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 80, 0, 160, 44)];
        label.text = message;
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.tableView.tableFooterView addSubview:label];
    //有数据
    } else {
        for (UIView *view in [self.tableView.tableFooterView subviews]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

@end
