//
//  GoodsView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/18.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"
#import "DLRadioButton.h"
#import "GoodsListView.h"

@protocol GoodsViewDelegate <NSObject>

//添加商品
- (void)actionAddGoods;

//全选
- (void)actionChooseAll:(DLRadioButton *)radio;

//删除
- (void) actionDeleteGoods: (DLRadioButton *) radio;

@end

@interface GoodsView : AppView

@property (retain , nonatomic) id<GoodsViewDelegate>delegate;

@property (retain , nonatomic) GoodsListView *listView;

- (void)setButtonAndButtomShowHide:(BOOL)type;

- (void)setCaseNo;

@end
