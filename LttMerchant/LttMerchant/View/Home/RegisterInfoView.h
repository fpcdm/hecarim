//
//  RegisterInfoView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppScrollView.h"
#import "MerchantEntity.h"

@protocol RegisterInfoViewDelegate <NSObject>

- (void)actoinRegister:(MerchantEntity *)merchant;

- (void)actionUploadImage:(NSString *)imgTag;

@end

@interface RegisterInfoView : AppScrollView

@property (retain , nonatomic) id<RegisterInfoViewDelegate>delegate;

- (void)setTipViewHide:(BOOL)type;

@end
