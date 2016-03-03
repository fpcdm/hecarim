//
//  BusinessAddView.h
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "AppScrollView.h"

@protocol BusinessAddViewDelegate <NSObject>

- (void)actionAddServices;

- (void)actionAddImage;

@end

@interface BusinessAddView : AppScrollView

@property (retain, nonatomic) id<BusinessAddViewDelegate>delegate;

- (void)showImg;

- (void)showServices;

@property (retain, nonatomic) UITextView *textView;

@property (retain, nonatomic) NSString *caseId;

@property (retain, nonatomic) NSArray *imgList;

@end
