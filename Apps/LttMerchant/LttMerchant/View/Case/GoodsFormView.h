//
//  GoodsFormView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/6.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppScrollView.h"

@protocol GoodsFormViewDelegate <NSObject>

- (void)actionChooseCategory: (UIButton *)sender;

- (void)actionChooseBrand: (UIButton *)sender;

- (void)actionChooseModel: (UIButton *)sender;

- (void)actionSave: (NSInteger)number;

- (void)actionChooseSpec:(NSMutableArray *)specData;

@end

@interface GoodsFormView : AppScrollView

@property (retain , nonatomic) id<GoodsFormViewDelegate>delegate;

@property (nonatomic, strong) UIButton *brandButton;

@property (nonatomic, strong) UIButton *modelButton;

- (void)setCaseNo;

//设置单价
- (void)setGoodsPrice:(NSString *)price;

//规格列表
- (void)specBox;


@end
