//
//  ZCTradeView.h
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//  交易密码视图\负责整个项目的交易密码输入

#import <UIKit/UIKit.h>

@class ZCTradeKeyboard;
@class ZCTradeView;

@protocol ZCTradeViewDelegate <NSObject>

@optional
/** 输入完成点击确定按钮 */
- (void)tradeViewFinish:(NSString *)pwd;
/** 取消按钮 */
- (void)tradeViewCancel;

@end

@interface ZCTradeView : UIView

@property (nonatomic, weak) id<ZCTradeViewDelegate> delegate;

/** 完成的回调block */
@property (nonatomic, copy) void (^finish) (NSString *passWord);

/** 取消的回调block */
@property (nonatomic, copy) void (^cancel) ();

/** 快速创建 */
+ (instancetype)tradeView;

/** 弹出 */
- (void)show;
- (void)showInView:(UIView *)view;

@end
