//
//  RegisterInfoView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RegisterInfoView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AddressEntity.h"

@interface RegisterInfoView ()<UITextFieldDelegate>

@end

@implementation RegisterInfoView
{
    UIView *tipView;
    UITextField *companyField;
    UITextField *addressField;
    UITextField *picField;
    UITextField *cardField;
    UIButton *proAreaBtn;
    UIButton *streetBtn;
    
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
    UIView *borderView;
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
    
    borderView = tipView;
    
    //单位名称输入框
    companyField = [AppUIUtil makeTextField];
    companyField.placeholder = @"请输入单位名称";
    companyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //单位名称视图
    borderView = [self makeView:@"单位名称" field:companyField];
    
    //省市视图
    proAreaBtn = [[UIButton alloc] init];
    proAreaBtn.layer.borderWidth = 0.5f;
    proAreaBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    proAreaBtn.layer.cornerRadius = 3.0f;
    proAreaBtn.backgroundColor = COLOR_MAIN_WHITE;
    proAreaBtn.titleLabel.font = FONT_MAIN;
    proAreaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    proAreaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [proAreaBtn setTitle:@"省，市，区" forState:UIControlStateNormal];
    [proAreaBtn setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [proAreaBtn addTarget:self action:@selector(actoinProArea) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:proAreaBtn];
    
    [proAreaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    
    UIImageView *proAreaImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chooseMethod"]];
;
    [proAreaBtn addSubview:proAreaImg];
    
    [proAreaImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(proAreaBtn.mas_centerY);
        make.right.equalTo(proAreaBtn.mas_right).offset(-padding);
        
        make.width.equalTo(@15);
        make.height.equalTo(@24);
    }];
    
    //街道视图
    streetBtn = [[UIButton alloc] init];
    streetBtn.layer.borderWidth = 0.5f;
    streetBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    streetBtn.layer.cornerRadius = 3.0f;
    streetBtn.backgroundColor = COLOR_MAIN_WHITE;
    streetBtn.titleLabel.font = FONT_MAIN;
    streetBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    streetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [streetBtn setTitle:@"街道" forState:UIControlStateNormal];
    [streetBtn setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [streetBtn addTarget:self action:@selector(actoinStreet) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:streetBtn];
    
    [streetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(proAreaBtn.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    
    UIImageView *streetImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chooseMethod"]];
;
    [streetBtn addSubview:streetImg];
    
    [streetImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(streetBtn.mas_centerY);
        make.right.equalTo(streetBtn.mas_right).offset(-padding);
        
        make.width.equalTo(@15);
        make.height.equalTo(@24);
    }];
    
    borderView = streetBtn;
    //单位地址输入框
    addressField = [AppUIUtil makeTextField];
    addressField.placeholder = @"请输入单位地址";
    addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    borderView = [self makeView:@"单位地址" field:addressField];
    
    //负责人输入框
    picField = [AppUIUtil makeTextField];
    picField.placeholder = @"请输入负责人的姓名";
    picField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    borderView = [self makeView:@"负责人" field:picField];
    
    //负责人输入框
    cardField = [AppUIUtil makeTextField];
    cardField.placeholder = @"请输入负责人的身份证号码";
    cardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    borderView = [self makeView:@"身份证号" field:cardField];
    
    //营业执照图片信息
    UILabel *licenseLabel = [[UILabel alloc] init];
    licenseLabel.text = @"上传清晰营业执照/其他证件";
    licenseLabel.textColor = COLOR_MAIN_BLACK;
    licenseLabel.font = FONT_MAIN;
    [self.contentView addSubview:licenseLabel];
    
    [licenseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderView.mas_bottom).offset(padding);
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

- (UIView *)makeView:(NSString *)labelName field:(UITextField *)field
{
    UIView *uiView = [[UIView alloc] init];
    uiView.layer.borderWidth = 0.5f;
    uiView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    uiView.layer.cornerRadius = 3.0f;
    uiView.backgroundColor = COLOR_MAIN_WHITE;
    [self.contentView addSubview:uiView];
    
    [uiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = labelName;
    label.textColor = COLOR_MAIN_BLACK;
    label.font = FONT_MAIN;
    [uiView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(uiView.mas_centerY);
        make.left.equalTo(uiView.mas_left).offset(padding);
        make.width.equalTo(@70);
    }];
    [uiView addSubview:field];
    
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(uiView.mas_centerY);
        make.left.equalTo(label.mas_right);
        make.right.equalTo(uiView.mas_right);
        make.height.equalTo(@30);
    }];
    return uiView;
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
    CGFloat height = 52 * 4 + 10 * 10 + 102 * 2 + 45 + 20 * 2 + tipHeight + 120;
    self.contentSize = CGSizeMake(SCREEN_WIDTH, height);
    
}

- (void)actoinProArea
{
    //隐藏键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.delegate actionProArea];
}

- (void)actoinStreet
{
    //隐藏键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.delegate actionStreet];
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

- (void)display
{
    MerchantEntity *merEntity = [self fetch:@"merEntity"];
    if ([@"license" isEqualToString:merEntity.type]) {
        licenseImageJ.hidden = YES;
        [merEntity imageView:licenseImage];
    } else if ([@"card" isEqualToString:merEntity.type]) {
        cardImageJ.hidden = YES;
        [merEntity imageView:cardImage];
    }
}

- (void)addressBox
{
    AddressEntity *address = [self fetch:@"address"];
    NSString *area = address.provinceName ? [address areaName] : @"省，市，区";
    NSString *street = address.streetName ? address.streetName : @"街道";
    [proAreaBtn setTitle:area forState:UIControlStateNormal];
    [streetBtn setTitle:street forState:UIControlStateNormal];
}

@end
