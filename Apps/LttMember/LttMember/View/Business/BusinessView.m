//
//  BusinessView.m
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessView.h"
#import "BusinessEntity.h"

@implementation BusinessView
{
    BusinessEntity *business;
    CGFloat scrollHeight;
    
    UIView *topView;
    UIView *middleView;
    UIView *bottomView;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_MAIN_WHITE;
        
        UIView *superview = self;
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(superview.mas_bottom).offset(-95);
        }];
        
        scrollHeight = 0;
    }
    return self;
}

- (void)display
{
    business = [self fetch:@"business"];
    
    [self topView];
    [self middleView];
    [self bottomView];
}

- (void)topView
{
    //公司名称
    UILabel *merchantLabel = [[UILabel alloc] init];
    merchantLabel.font = FONT_MAIN;
    merchantLabel.textColor = [UIColor colorWithHex:@"#0099CC"];
    merchantLabel.text = business.merchantName;
    [self.contentView addSubview:merchantLabel];
    
    UIView *superview = self.contentView;
    [merchantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@16);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = FONT_MAIN;
    contentLabel.textColor = COLOR_MAIN_BLACK;
    contentLabel.numberOfLines = 0;
    contentLabel.text = business.content;
    [self.contentView addSubview:contentLabel];
    
    CGFloat textHeight = [self adjustTextHeight:business.content];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(merchantLabel.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@(textHeight + 4));
    }];
    
    scrollHeight += 40 + textHeight;
}

- (void)middleView
{
    //有图片
    NSArray *images = business.images;
    if (images.isNotEmpty) {
        //计算宽高
        NSInteger buttonSize = 3;
        CGFloat buttonWidth = (SCREEN_WIDTH - 60) / buttonSize;
        CGFloat buttonHeight = buttonWidth + 20;
        CGFloat spaceWidth = 60 / buttonSize;
        CGFloat spaceHeight = 10;
        
        //绘制图片
        NSInteger imagesCount = [images count];
        CGFloat frameX = 0;
        CGFloat frameY = 0;
        for (int i = 0; i < imagesCount; i++) {
            //计算位置
            NSInteger itemRow = (int)(i / buttonSize) + 1;
            NSInteger itemCol = i % buttonSize + 1;
            frameX = spaceWidth / 2 + (buttonWidth + spaceWidth) * (itemCol - 1);
            frameY = buttonHeight * (itemRow - 1);
            
            //添加按钮
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY + scrollHeight + spaceHeight, buttonWidth, buttonHeight - 20)];
            [button addTarget:self action:@selector(actionPreview:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = COLOR_MAIN_CLEAR;
            button.tag = i;
            [self.contentView addSubview:button];
            
            //添加图片
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:button.bounds];
            [button addSubview:imageView];
            
            //加载图片
            ImageEntity *image = [images objectAtIndex:i];
            [imageView setImageUrl:image.thumbUrl indicator:YES];
        }
        
        //计算容器宽高
        scrollHeight += frameY + buttonHeight;
    }
    
    //适应尺寸
    self.contentSize = CGSizeMake(SCREEN_WIDTH, scrollHeight);
}

- (void)bottomView
{
    //支付按钮
    UIButton *button = [AppUIUtil makeButton:@"呼叫商家"];
    [button addTarget:self action:@selector(actionBusiness) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIView *superview = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.bottom.equalTo(superview.mas_bottom).offset(-40);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
}

- (CGFloat) adjustTextHeight:(NSString *)content
{
    if (!content || content.length < 1) return 0;
    
    CGSize size = [content boundingSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) withFont:FONT_MAIN];
    return size.height;
}

#pragma mark - Action
- (void)actionBusiness
{
    [self.delegate actionBusiness];
}

- (void)actionPreview:(UIButton *)button
{
    [self.delegate actionPreview:button.tag];
}

@end
