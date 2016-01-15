//
//  ServiceView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/17.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"
#import "ServiceListView.h"
#import "DLRadioButton.h"

@protocol ServiceViewDelegate <NSObject>

//添加服务
- (void)actionAddService;

//全选按钮
- (void)actionChooseAll:(DLRadioButton *)radio;

//删除服务
- (void)actionDeleteServices:(DLRadioButton *)radio;

@end

@interface ServiceView : AppView

@property (retain , nonatomic) id<ServiceViewDelegate>delegate;

@property (retain , nonatomic) ServiceListView *listView;

//显示或隐藏添加、全选、删除
- (void)setButtonAndButtomShowHide:(BOOL)type;

- (void)setCaseNo;

@end
