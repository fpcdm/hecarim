//
//  BusinessAddView.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessAddView.h"
#import "BusinessEntity.h"

@implementation BusinessAddView
{
    UIView *imagesBox;
    UIButton *addButton;
    UILabel *servicesNameLabel;
}

@synthesize textView,caseId,imgList;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self.contentView;
    int padding = 10;
    
    UIView *textViewBg = [UIView new];
    textViewBg.backgroundColor = COLOR_MAIN_WHITE;
    textViewBg.layer.borderWidth = 0.5f;
    textViewBg.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [self.contentView addSubview:textViewBg];
    
    [textViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        
        make.height.equalTo(@120);
        
    }];
    
    textView = [[UITextView alloc] init];
    textView.placeholder = @"信息内容";
    [textViewBg addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textViewBg.mas_top);
        make.left.equalTo(textViewBg.mas_left).offset(5);
        make.bottom.equalTo(textViewBg.mas_bottom);
        make.right.equalTo(textViewBg.mas_right).offset(-5);
    }];
    
    CGFloat wh = (SCREEN_WIDTH - 60) / 5;
    imagesBox = [[UIView alloc] init];
    imagesBox.layer.borderWidth = 0.5f;
    imagesBox.layer.borderColor = CGCOLOR_MAIN_BORDER;
    imagesBox.backgroundColor = COLOR_MAIN_WHITE;
    [self.contentView addSubview:imagesBox];
    
    [imagesBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textViewBg.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        
        make.height.equalTo(@(wh+20));
    }];
    
    addButton = [[UIButton alloc] init];
    addButton.layer.borderWidth = 0.5f;
    addButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [addButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(actionAddImage) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(10, 10, wh, wh);
    [imagesBox addSubview:addButton];
    
    UIImageView *addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_add"]];
    [addButton addSubview:addImageView];
    
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addButton.mas_centerX);
        make.centerY.equalTo(addButton.mas_centerY);
        
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    UIButton *servicesBtn = [[UIButton alloc] init];
    servicesBtn.layer.borderWidth = 0.5f;
    servicesBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    servicesBtn.backgroundColor = COLOR_MAIN_WHITE;
    servicesBtn.titleLabel.font = FONT_MAIN;
    [servicesBtn addTarget:self action:@selector(actionAddServices) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:servicesBtn];
    
    [servicesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imagesBox.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        
        make.height.equalTo(@50);
    }];
    
    servicesNameLabel = [[UILabel alloc] init];
    servicesNameLabel.text = @"绑定服务";
    servicesNameLabel.font = FONT_MAIN;
    [servicesBtn addSubview:servicesNameLabel];
    
    [servicesNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(servicesBtn.mas_centerY);
        make.left.equalTo(servicesBtn.mas_left).offset(padding);
        
        make.height.equalTo(@20);
    }];
    
    //箭头
    UILabel *arrowLabel = [[UILabel alloc] init];
    arrowLabel.text = @">";
    arrowLabel.textColor = COLOR_MAIN_GRAY;
    arrowLabel.font = [UIFont systemFontOfSize:20];
    [servicesBtn addSubview:arrowLabel];
    
    [arrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(servicesBtn.mas_centerY);
        make.right.equalTo(servicesBtn.mas_right).offset(-padding);
    }];
    
    //关闭键盘Toolbar
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [keyboardToolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];
    NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    
    [keyboardToolbar setItems:buttonsArray];
    [textView setInputAccessoryView:keyboardToolbar];
    
    self.contentSize = CGSizeMake(SCREEN_WIDTH, 120 + wh + 20 + 50 + 10 * 4);
    
    return self;
}

#pragma mark - TextView
- (void)dismissKeyboard
{
    [textView resignFirstResponder];
}

- (void)actionAddImage
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.delegate actionAddImage];
}

- (void)actionAddServices
{
    [self.delegate actionAddServices];
}

- (void)showImg
{
    NSArray *imgArr = [self fetch:@"newsImgs"];
    [FWDebug dump:imgArr];
    CGFloat wh = (SCREEN_WIDTH - 60) / 5;
    CGFloat boxHeight = ceil((imgArr.count + 1) / 5.0) * wh + (ceil((imgArr.count + 1) / 5.0) + 1) * 10;
    
    [imagesBox mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(boxHeight));
    }];
    
    int i = 0;
    int y = 0;
    int x = 0;
    
    BusinessEntity *businessEntity = [[BusinessEntity alloc] init];
    for (NSString *imgUrl in imgArr) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [businessEntity uploadPicView:imageView imgUrl:imgUrl];
                imageView.frame = CGRectMake(wh * x + 10*(x+1), wh * y + 10*(y+1), wh, wh);
        [imagesBox addSubview:imageView];
        x++;
        i++;
        if (i % 5 == 0 && i > 1) {
            y++;
            x = 0;
        }
    }
    addButton.frame = CGRectMake(wh * x + 10*(x+1), wh * y + 10*(y+1), wh, wh);
    self.contentSize = CGSizeMake(SCREEN_WIDTH, 120 + boxHeight + 50 + 10 * 4);
}

- (void)showServices
{
    NSDictionary *servicesData = [self fetch:@"selectServices"];
    servicesNameLabel.text = [servicesData objectForKey:@"type_name"];
}

@end
