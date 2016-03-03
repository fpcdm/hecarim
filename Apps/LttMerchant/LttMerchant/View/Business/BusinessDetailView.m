//
//  BusinessDetailView.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessDetailView.h"

@implementation BusinessDetailView
{
    UIView *superView;
    int padding;
}
- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    superView = self.contentView;
    padding  = 10;
        
    return self;
}

- (CGFloat)getContentHeight:(NSString *)content
{
    if (!content || content.length < 1) return 0;
    
    CGSize textSize=[content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_MAIN} context:nil].size;
    CGRect textF=CGRectMake(0, 0, textSize.width, textSize.height);
    
    CGFloat cellHeight = CGRectGetMaxY(textF)+10;
    return cellHeight;
}

- (CGFloat)getImagesHeight:(NSArray *)imgsList
{
    if (imgsList.count < 1) return 0;
    
    CGFloat wh = (SCREEN_WIDTH - 40) / 3;
    CGFloat boxHeight = ceil((imgsList.count) / 3.0) * wh + (ceil((imgsList.count) / 3.0) + 1) * 10;
    
    return boxHeight;
}

- (void)showImg:(UIView *)imagesBox imgsList:(NSArray *)imgArr
{
    CGFloat wh = (SCREEN_WIDTH - 40) / 3;
    
    int i = 0;
    int y = 0;
    int x = 0;
    
    for (NSDictionary *imgs in imgArr) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(wh * x + 10*(x+1), wh * y + 10*(y+1), wh, wh)];
        [imagesBox addSubview:imageView];
        [imageView setImageUrl:[imgs objectForKey:@"thumb_url"] indicator:YES];
        x++;
        i++;
        if (i % 3 == 0 && i > 1) {
            y++;
            x = 0;
        }
    }
}


- (void)display
{
    BusinessEntity *businessEntity = [self fetch:@"businessDetail"];
    
    CGFloat height = [self getContentHeight:businessEntity.newsContent];
    CGFloat imagesBoxHeight = [self getImagesHeight:businessEntity.newsImgs];
    CGFloat bgHeight = height + imagesBoxHeight + 50;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = COLOR_MAIN_WHITE;
    bgView.layer.borderWidth = 0.5f;
    bgView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        
        make.height.equalTo(@(bgHeight));
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = businessEntity.newsContent;
    contentLabel.textColor = COLOR_MAIN_BLACK;
    contentLabel.font = FONT_MAIN;
    contentLabel.numberOfLines = 0;
    [bgView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(5);
        make.left.equalTo(bgView.mas_left).offset(padding);
        make.right.equalTo(bgView.mas_right).offset(-padding);
        
        make.height.equalTo(@(height));
    }];
    
    UIView *imageBox = [[UIView alloc] init];
    imageBox.hidden = NO;
    [bgView addSubview:imageBox];
    
    [imageBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(padding);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
        
        make.height.equalTo(@(imagesBoxHeight));
    }];
    
    [self showImg:imageBox imgsList:businessEntity.newsImgs];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = businessEntity.createTime;
    timeLabel.textColor = COLOR_MAIN_GRAY;
    timeLabel.font = FONT_MAIN;
    [bgView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageBox.mas_bottom).offset(padding);
        make.left.equalTo(bgView.mas_left).offset(padding);
        make.bottom.equalTo(bgView.mas_bottom).offset(-padding);
        
        make.height.equalTo(@20);
    }];
    
    UIButton *delBtn = [[UIButton alloc] init];
    delBtn.backgroundColor = [UIColor clearColor];
    delBtn.titleLabel.font = FONT_MAIN;
    NSInteger tag = [businessEntity.newsId intValue];
    delBtn.tag = tag;
    [delBtn addTarget:self action:@selector(actionDeleteBusiness:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *delStr = [[NSMutableAttributedString alloc]initWithString:@"删除"];
    NSRange contentRange = {0,[delStr length]};
    
    [delStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_BLUE range:contentRange];
    [delStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [delBtn setAttributedTitle:delStr forState:UIControlStateNormal];
    [bgView addSubview:delBtn];
    
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_top);
        make.left.equalTo(timeLabel.mas_right).offset(padding);
        make.bottom.equalTo(bgView.mas_bottom).offset(-padding);
    }];
    
    self.contentSize = CGSizeMake(SCREEN_WIDTH, bgHeight+10);
    
}

- (void)actionDeleteBusiness:(UIButton *)sender
{
    BusinessEntity *business = [[BusinessEntity alloc] init];
    business.id = [NSNumber numberWithInteger:sender.tag];
    [self.delegate deleteBusiness:business];
}

@end
