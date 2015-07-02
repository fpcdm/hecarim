//
//  BaseTableViewController.h
//  LttCustomer
//
//  Created by wuyong on 15/4/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKitUtil.h"
#import "AppViewController.h"

@interface AppTableViewController : UITableViewController
{
    //是否禁用菜单
    BOOL isMenuDisabled;
    
    //左侧菜单是否为返回
    BOOL isMenuBack;
    
    //是否隐藏远程通知提示
    BOOL hideRemoteNotification;
}

@property (strong, nonatomic) NSMutableArray *tableData;

- (void) showEmpty: (NSString *) message;

- (BOOL) isLogin;

//检查远程通知
- (void) checkRemoteNotification;

//根据类型处理远程通知
- (void) handleRemoteNotification:(NSString *) type data: (NSString *) data;

@end
