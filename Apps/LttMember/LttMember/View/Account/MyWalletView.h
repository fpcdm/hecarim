//
//  MyWalletView.h
//  LttMember
//
//  Created by 杨海锋 on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol MyWalletViewDelegate <NSObject>

- (void)actionBalance;

- (void)actionRecharge;

@end

@interface MyWalletView : AppTableView

@property (retain , nonatomic) id<MyWalletViewDelegate>delegate;

@end
