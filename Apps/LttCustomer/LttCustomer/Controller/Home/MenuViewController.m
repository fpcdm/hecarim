//
//  BaseMenuController.m
//  LttMerchant
//
//  Created by wuyong on 15/4/27.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "MenuViewController.h"
#import "AppExtension.h"
#import "CaseListViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
{
    NSArray *menuList;
    UserEntity *user;
    UIImageView *userImageView;
    UILabel *userNameLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.opaque = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        userImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        userImageView.image = [UIImage imageNamed:@"nopic"];
        userImageView.layer.masksToBounds = YES;
        userImageView.layer.cornerRadius = 50.0;
        userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        userImageView.layer.borderWidth = 3.0f;
        userImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        userImageView.layer.shouldRasterize = YES;
        userImageView.clipsToBounds = YES;
        
        userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        userNameLabel.text = @"未登陆";
        userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [userNameLabel sizeToFit];
        userNameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:userImageView];
        [view addSubview:userNameLabel];
        view;
    });
    
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    self.tableView.tableFooterView = tableFooterView;
    
    [self loadData];
}

- (void) loadData
{
    user = [[StorageUtil sharedStorage] getUser];
    
    //未登录
    if (!user) {
        menuList = [[NSArray alloc] initWithObjects:
                    @[@"首页", @"HomeViewController"],
                    @[@"登陆", @"LoginViewController"],
                    nil];
        
        userNameLabel.text = @"未登录";
        [userNameLabel sizeToFit];
        userImageView.image = [UIImage imageNamed:@"nopic"];
        //已登录
    } else {
        menuList = [[NSArray alloc] initWithObjects:
                    @[@"首页", @"HomeViewController"],
                    @[@"服务单", @"CaseListViewController"],
                    @[@"账户", @"AccountViewController"],
                    nil];
        
        userNameLabel.text = [user displayName];
        [userNameLabel sizeToFit];
        [user avatarView:userImageView];
    }
}

- (void) refresh
{
    [self loadData];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"用户菜单";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 34;
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *menu = [menuList objectAtIndex:[indexPath row]];
    
    AppViewController *viewController = [[NSClassFromString([menu objectAtIndex:1]) alloc] init];
    
    //切换viewController
    UINavigationController *navigationController = (UINavigationController *) self.frostedViewController.contentViewController;
    [navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
    
    [self.frostedViewController hideMenuViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [menuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray *menu = (NSArray *) [menuList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [menu objectAtIndex:0];
    
    return cell;
}

@end