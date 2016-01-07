//
//  ZCTradeInputView.m
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

#define ZCTradeInputViewNumCount 6

// 快速生成颜色
#define ZCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

typedef enum {
    ZCTradeInputViewButtonTypeWithCancle = 10000,
    ZCTradeInputViewButtonTypeWithOk = 20000,
    ZCTradeInputViewButtonTypeWithTitle = 30000,
}ZCTradeInputViewButtonType;

#import "ZCTradeInputView.h"
#import "ZCTradeKeyboard.h"

@interface ZCTradeInputView ()
/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 确定按钮 */
@property (nonatomic, weak) UIButton *okBtn;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancleBtn;
@end

@implementation ZCTradeInputView

#pragma mark - LazyLoad

- (NSMutableArray *)nums
{
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        /** 注册keyboard通知 */
        [self setupKeyboardNote];
        /** 添加子控件 */
        [self setupSubViews];
    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViews
{
    /** 标题标签 */
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.text = @"请输入支付密码";
    self.titleLabel.font = [UIFont systemFontOfSize:ZCScreenWidth * 0.053125];
    self.titleLabel.textColor = ZCColor(102, 102, 102);
    self.titleLabel.tag = ZCTradeInputViewButtonTypeWithTitle;
    
    /** 确定按钮 */
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:okBtn];
    self.okBtn = okBtn;
    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_up"] forState:UIControlStateNormal];
    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_down"] forState:UIControlStateHighlighted];
    [self.okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.okBtn.tag = ZCTradeInputViewButtonTypeWithOk;
    
    /** 取消按钮 */
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_up"] forState:UIControlStateNormal];
    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_down"] forState:UIControlStateHighlighted];
    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn.tag = ZCTradeInputViewButtonTypeWithCancle;
}

/** 注册keyboard通知 */
- (void)setupKeyboardNote
{
    // 删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:ZCTradeKeyboardDeleteButtonClick object:nil];
    
    // 确定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ok) name:ZCTradeKeyboardOkButtonClick object:nil];
    
    // 数字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:ZCTradeKeyboardNumberButtonClick object:nil];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /** 标题标签 */
    [self layoutTitleLabel];
    
    /** 取消按钮 */
    self.cancleBtn.width = ZCScreenWidth * 0.409375;
    self.cancleBtn.height = ZCScreenWidth * 0.128125;
    self.cancleBtn.x = ZCScreenWidth * 0.05;
    self.cancleBtn.y = self.height - (ZCScreenWidth * 0.05 + self.cancleBtn.height);
    
    /** 确定按钮 */
    self.okBtn.y = self.cancleBtn.y;
    self.okBtn.width = self.cancleBtn.width;
    self.okBtn.height = self.cancleBtn.height;
    self.okBtn.x = CGRectGetMaxX(self.cancleBtn.frame) + ZCScreenWidth * 0.025;
}

- (void)layoutTitleLabel
{
    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:ZCScreenWidth * 0.053125]} context:nil].size;
    self.titleLabel.width = size.width;
    self.titleLabel.height = size.height;
    self.titleLabel.x = (self.width - size.width) * 0.5;
    self.titleLabel.y = ZCScreenWidth * 0.03125;
}

- (void)setTitle:(NSString *)title color:(UIColor *)color
{
    self.titleLabel.text = title;
    self.titleLabel.textColor = color ? color : ZCColor(102, 102, 102);
    [self layoutTitleLabel];
}

#pragma mark - Private

// 删除
- (void)delete
{
    [self.nums removeLastObject];
    [self setNeedsDisplay];
}

// 数字
- (void)number:(NSNotification *)note
{
    if (self.nums.count >= ZCTradeInputViewNumCount) return;
    NSDictionary *userInfo = note.userInfo;
    NSNumber *numObj = userInfo[ZCTradeKeyboardNumberKey];
    [self.nums addObject:numObj];
    [self setNeedsDisplay];
}

// 确定
- (void)ok
{
    
}

// 按钮点击
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == ZCTradeInputViewButtonTypeWithCancle) {  // 取消按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:cancleBtnClick:)]) {
            [self.delegate tradeInputView:self cancleBtnClick:btn];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeInputViewCancleButtonClick object:self];
    } else if (btn.tag == ZCTradeInputViewButtonTypeWithOk) {  // 确定按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:okBtnClick:)]) {
            [self.delegate tradeInputView:self okBtnClick:btn];
        }
        // 包装通知字典
        NSMutableString *pwd = [NSMutableString string];
        for (int i = 0; i < self.nums.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@", self.nums[i]];
            [pwd appendString:str];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[ZCTradeInputViewPwdKey] = pwd;
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeInputViewOkButtonClick object:self userInfo:dict];
    } else {
        
    }
}

- (void)drawRect:(CGRect)rect
{
    // 画图
    UIImage *bg = [UIImage imageNamed:@"trade.bundle/pssword_bg"];
    UIImage *field = [UIImage imageNamed:@"trade.bundle/password_in"];
    
    [bg drawInRect:rect];
    
    CGFloat x = ZCScreenWidth * 0.096875 * 0.5;
    CGFloat y = ZCScreenWidth * 0.40625 * 0.5;
    CGFloat w = ZCScreenWidth * 0.846875;
    CGFloat h = ZCScreenWidth * 0.121875;
    [field drawInRect:CGRectMake(x, y, w, h)];
    
    // 画点
    UIImage *pointImage = [UIImage imageNamed:@"trade.bundle/yuan"];
    CGFloat pointW = ZCScreenWidth * 0.05;
    CGFloat pointH = pointW;
    CGFloat pointY = ZCScreenWidth * 0.24;
    CGFloat pointX;
    CGFloat margin = ZCScreenWidth * 0.0484375;
    CGFloat padding = ZCScreenWidth * 0.045578125;
    for (int i = 0; i < self.nums.count; i++) {
        pointX = margin + padding + i * (pointW + 2 * padding);
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
    
    // ok按钮状态
    BOOL statue = NO;
    if (self.nums.count == ZCTradeInputViewNumCount) {
        statue = YES;
    } else {
        statue = NO;
    }
    self.okBtn.enabled = statue;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
