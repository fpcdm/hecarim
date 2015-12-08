//
//  RegisterInfoView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RegisterInfoView.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface RegisterInfoView ()<UITextFieldDelegate>

@end

@implementation RegisterInfoView
{
    UIView *tipView;
    UITextField *companyField;
    UITextField *addressField;
    UITextField *picField;
    UITextField *cardField;
    
    UIView *superView;
    int padding;
    
    UIImageView *licenseImage;
    UIImageView *licenseImageJ;
    UIImageView *cardImage;
    UIImageView *cardImageJ;
    CGFloat imgHeight;
    
    UIButton *licenseBtn;
    UIButton *cardBtn;
    CGFloat _totalYOffset;
}

- (UIScrollView *)loadScrollView
{
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = NO;
    return scrollView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;

    superView = self.contentView;
    padding = 10;
    imgHeight = 100;
    
    tipView = [[UIView alloc] init];
    tipView.hidden = YES;
    tipView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:tipView];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@60);
    }];
    
    //提示信息
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"请输入你的商家信息，以申请开通商家权限\n你的商家用户密码为你正在使用的手机号和密码";
    tipLabel.textColor = [UIColor redColor];
    tipLabel.font = FONT_MIDDLE;
    tipLabel.numberOfLines = 2;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [tipView addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_top);
        make.left.equalTo(tipView.mas_left);
        make.right.equalTo(tipView.mas_right);
    }];
    
    //密码提示信息
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.text = @"如果忘记密码，请先找回密码";
    passwordLabel.textColor = [UIColor redColor];
    passwordLabel.font = FONT_MIDDLE;
    [tipView addSubview:passwordLabel];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(padding);
        make.left.equalTo(tipView.mas_left);
        make.right.equalTo(tipView.mas_right);
    }];
    
    UIView *newView = tipView;
    
    //单位名称视图
    UIView *companyView = [[UIView alloc] init];
    companyView.layer.borderWidth = 0.5f;
    companyView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    companyView.layer.cornerRadius = 3.0f;
    companyView.backgroundColor = COLOR_MAIN_WHITE;
    [self.contentView addSubview:companyView];
    
    [companyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    //单位名称
    UILabel *companyLabel = [[UILabel alloc] init];
    companyLabel.text = @"单位名称";
    companyLabel.textColor = COLOR_MAIN_BLACK;
    companyLabel.font = FONT_MAIN;
    [companyView addSubview:companyLabel];
    
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(companyView.mas_centerY);
        make.left.equalTo(companyView.mas_left).offset(padding);
        make.width.equalTo(@70);
    }];
    //单位名称输入框
    companyField = [AppUIUtil makeTextField];
    companyField.placeholder = @"请输入单位名称";
    companyField.textColor = COLOR_MAIN_BLACK;
    companyField.font = FONT_MAIN;
    companyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [companyView addSubview:companyField];
    
    [companyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(companyView.mas_centerY);
        make.left.equalTo(companyLabel.mas_right);
        make.right.equalTo(companyView.mas_right);
        make.height.equalTo(@30);
    }];
    
    //单位地址视图
    UIView *addressView = [[UIView alloc] init];
    addressView.layer.borderWidth = 0.5f;
    addressView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    addressView.layer.cornerRadius = 3.0f;
    addressView.backgroundColor = COLOR_MAIN_WHITE;
    [self.contentView addSubview:addressView];
    
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    //单位地址
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"单位地址";
    addressLabel.textColor = COLOR_MAIN_BLACK;
    addressLabel.font = FONT_MAIN;
    [addressView addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView.mas_centerY);
        make.left.equalTo(addressView.mas_left).offset(padding);
        make.width.equalTo(@70);
    }];
    //单位地址输入框
    addressField = [AppUIUtil makeTextField];
    addressField.placeholder = @"请输入单位地址";
    addressField.textColor = COLOR_MAIN_BLACK;
    addressField.font = FONT_MAIN;
    addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [addressView addSubview:addressField];
    
    [addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView.mas_centerY);
        make.left.equalTo(addressLabel.mas_right);
        make.right.equalTo(addressView.mas_right);
        make.height.equalTo(@30);
    }];
    
    
    //负责人视图
    UIView *picView = [[UIView alloc] init];
    picView.layer.borderWidth = 0.5f;
    picView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    picView.layer.cornerRadius = 3.0f;
    picView.backgroundColor = COLOR_MAIN_WHITE;
    [self.contentView addSubview:picView];
    
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    //负责人
    UILabel *picLabel = [[UILabel alloc] init];
    picLabel.text = @"负责人";
    picLabel.textColor = COLOR_MAIN_BLACK;
    picLabel.font = FONT_MAIN;
    [picView addSubview:picLabel];
    
    [picLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(picView.mas_centerY);
        make.left.equalTo(picView.mas_left).offset(padding);
        make.width.equalTo(@70);
    }];
    //负责人输入框
    picField = [AppUIUtil makeTextField];
    picField.placeholder = @"请输入负责人的姓名";
    picField.textColor = COLOR_MAIN_BLACK;
    picField.font = FONT_MAIN;
    picField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [picView addSubview:picField];
    
    [picField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(picView.mas_centerY);
        make.left.equalTo(picLabel.mas_right);
        make.right.equalTo(picView.mas_right);
        make.height.equalTo(@30);
    }];
    
    
    //身份证视图
    UIView *cardView = [[UIView alloc] init];
    cardView.layer.borderWidth = 0.5f;
    cardView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    cardView.layer.cornerRadius = 3.0f;
    cardView.backgroundColor = COLOR_MAIN_WHITE;
    [self.contentView addSubview:cardView];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(picView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    //身份证
    UILabel *cardLabel = [[UILabel alloc] init];
    cardLabel.text = @"身份证号";
    cardLabel.textColor = COLOR_MAIN_BLACK;
    cardLabel.font = FONT_MAIN;
    [cardView addSubview:cardLabel];
    
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView.mas_centerY);
        make.left.equalTo(cardView.mas_left).offset(padding);
        make.width.equalTo(@70);
    }];
    //负责人输入框
    cardField = [AppUIUtil makeTextField];
    cardField.placeholder = @"请输入负责人的身份证号码";
    cardField.textColor = COLOR_MAIN_BLACK;
    cardField.font = FONT_MAIN;
    cardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cardView addSubview:cardField];
    
    [cardField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView.mas_centerY);
        make.left.equalTo(cardLabel.mas_right);
        make.right.equalTo(cardView.mas_right);
        make.height.equalTo(@30);
    }];
    
    //营业执照图片信息
    UILabel *licenseLabel = [[UILabel alloc] init];
    licenseLabel.text = @"上传清晰营业执照";
    licenseLabel.textColor = COLOR_MAIN_BLACK;
    licenseLabel.font = FONT_MAIN;
    [self.contentView addSubview:licenseLabel];
    
    [licenseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@20);
    }];
    
    //营业执照图片边框视图
    licenseBtn = [[UIButton alloc] init];
    licenseBtn.layer.borderWidth = 0.5f;
    licenseBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    licenseBtn.layer.cornerRadius = 3.0f;
    licenseBtn.backgroundColor = COLOR_MAIN_WHITE;
    [licenseBtn addTarget:self action:@selector(actionUploadLisense) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:licenseBtn];
    
    [licenseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(licenseLabel.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@(imgHeight));
    }];
    
    //营业执照图片
    licenseImage = [[UIImageView alloc] init];
    licenseImage.layer.cornerRadius = 3.0f;
    //子视图被剪切到父视图的边界
    licenseImage.clipsToBounds = YES;
    licenseImage.contentMode = UIViewContentModeScaleAspectFit;
    [licenseBtn addSubview:licenseImage];
    
    [licenseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(licenseBtn.mas_centerX);
        make.centerY.equalTo(licenseBtn.mas_centerY);
        make.top.equalTo(licenseBtn.mas_top).offset(1);
        make.left.equalTo(licenseBtn.mas_left).offset(1);
        make.right.equalTo(licenseBtn.mas_right).offset(-1);
        make.bottom.equalTo(licenseBtn.mas_bottom).offset(-1);
    }];

    //加图片
    licenseImageJ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_add"]];
    
    [licenseBtn addSubview:licenseImageJ];
    
    [licenseImageJ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(licenseBtn.mas_centerX);
        make.centerY.equalTo(licenseBtn.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    //身份证清晰正面图
    UILabel *cardImageLabel = [[UILabel alloc] init];
    cardImageLabel.text = @"上传清晰身份证正面照";
    cardImageLabel.textColor = COLOR_MAIN_BLACK;
    cardImageLabel.font = FONT_MAIN;
    [self.contentView addSubview:cardImageLabel];
    
    [cardImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(licenseBtn.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@20);
    }];
    
    
    cardBtn = [[UIButton alloc] init];
    cardBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    cardBtn.layer.borderWidth = 0.5f;
    cardBtn.layer.cornerRadius = 3.0f;
    cardBtn.backgroundColor = COLOR_MAIN_WHITE;
    cardBtn.tag = 2;
    [cardBtn addTarget:self action:@selector(actionUploadCard) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cardBtn];
    
    [cardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardImageLabel.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@(imgHeight));
    }];
    
    
    cardImage = [[UIImageView alloc] init];
    cardImage.layer.cornerRadius = 3.0f;
    cardImage.clipsToBounds = YES;
    cardImage.contentMode = UIViewContentModeScaleAspectFit;
    [cardBtn addSubview:cardImage];
    
    [cardImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cardBtn.mas_centerX);
        make.centerY.equalTo(cardBtn.mas_centerY);
        make.top.equalTo(cardBtn.mas_top).offset(1);
        make.left.equalTo(cardBtn.mas_left).offset(1);
        make.right.equalTo(cardBtn.mas_right).offset(-1);
        make.bottom.equalTo(cardBtn.mas_bottom).offset(-1);
    }];
    
    //身份证加图片
    cardImageJ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_add"]];
    [cardBtn addSubview:cardImageJ];
    
    [cardImageJ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cardBtn.mas_centerX);
        make.centerY.equalTo(cardBtn.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"确定"];
    button.titleLabel.font = FONT_MAIN;
    [button addTarget:self action:@selector(actoinMercantRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardBtn.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];

    return self;
}

- (void)setTipViewHide:(BOOL)type
{
    CGFloat tipHeight = 0;
    if (type) {
        tipView.hidden = NO;
        [tipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
            make.top.equalTo(superView.mas_top).offset(padding);
        }];
        tipHeight = 72;
    } else {
        tipView.hidden = YES;
        [tipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.top.equalTo(superView.mas_top);
        }];
    }
    CGFloat height = 52 * 4 + 10 * 10 + 102 * 2 + 45 + 20 * 2 + tipHeight;
    self.contentSize = CGSizeMake(SCREEN_WIDTH, height);
    
}

- (void)actoinMercantRegister
{
    MerchantEntity *entity = [[MerchantEntity alloc] init];
    entity.merchant_name = companyField.text;
    entity.merchant_address = addressField.text;
    entity.contacter = picField.text;
    entity.contacter_id = cardField.text;
    [self.delegate actoinRegister:entity];
}

//上传营业执照
- (void)actionUploadLisense
{
    [self.delegate actionUploadImage:@"license"];
}

//上传身份证正面图
- (void)actionUploadCard
{
    [self.delegate actionUploadImage:@"card"];
}

- (void)renderData
{
    MerchantEntity *merEntity = [self getData:@"merEntity"];
    if ([@"license" isEqualToString:merEntity.type]) {
        licenseImageJ.hidden = YES;
        [merEntity imageView:licenseImage];
    } else if ([@"card" isEqualToString:merEntity.type]) {
        cardImageJ.hidden = YES;
        [merEntity imageView:cardImage];
    }
}

@end
