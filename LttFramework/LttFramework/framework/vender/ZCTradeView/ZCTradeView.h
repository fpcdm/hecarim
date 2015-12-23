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
/** 输入完成点击确定按钮，返回YES自动关闭弹框 */
- (BOOL)tradeViewFinish:(NSString *)pwd;
/** 取消按钮，返回YES自动关闭弹框 */
- (BOOL)tradeViewCancel;

@end

@interface ZCTradeView : UIView

@property (nonatomic, weak) id<ZCTradeViewDelegate> delegate;

/** 完成的回调block */
@property (nonatomic, copy) BOOL (^finish) (NSString *passWord);

/** 取消的回调block */
@property (nonatomic, copy) BOOL (^cancel) ();

/** 快速创建 */
+ (instancetype)tradeView;

/** 设置标题 */
- (void)setTitle:(NSString *)title color:(UIColor *)color;

/** 弹出 */
- (void)show;
- (void)showInView:(UIView *)view;

/** 移除 */
- (void)hide;
- (void)hide:(void (^)())completion;

/** 输入框抖动 */
- (void)shake;

@end
