//
//  GoodsFormView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/6.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "GoodsFormView.h"
#import "CaseEntity.h"
#import "SpecEntity.h"

@implementation GoodsFormView
{
    UILabel *caseNo;
    UILabel *statusName;
    UIButton *categoryBtn;
    UILabel *goodsPrice;
    UILabel *goodsNumber;
    UILabel *tipSpecLabel;
    UIView *specView;
    int padding;
    int paddingTop;
    CGFloat x;
    CGFloat space;
    NSMutableArray *specSelectedData;
    NSMutableArray *buttons;
    
    UIView *specListView;
    NSInteger selectCount;
    NSInteger specCount;
    CGFloat height;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self.contentView;
    padding = 10;
    paddingTop = 5;
    
    //头部视图
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"8ed1f3"];
    [self.contentView addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@50);
    }];
    
    //图片
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_icon_white"]];
    [headerView addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.left.equalTo(headerView.mas_left).offset(padding);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    //编号
    UILabel *caseNoLabel = [[UILabel alloc] init];
    caseNoLabel.text = @"编号:";
    caseNoLabel.font = FONT_MAIN;
    caseNoLabel.textColor = COLOR_MAIN_WHITE;
    [headerView addSubview:caseNoLabel];
    
    [caseNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.left.equalTo(image.mas_right).offset(padding);
    }];
    //编号内容
    caseNo = [[UILabel alloc] init];
    caseNo.textColor = COLOR_MAIN_WHITE;
    caseNo.font = FONT_MAIN;
    [headerView addSubview:caseNo];
    
    [caseNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.left.equalTo(caseNoLabel.mas_right).offset(padding);
    }];
    
    //状态
    statusName = [[UILabel alloc] init];
    statusName.textColor = COLOR_MAIN_WHITE;
    statusName.font = FONT_MAIN;
    [headerView addSubview:statusName];
    
    [statusName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.right.equalTo(headerView.mas_right).offset(-padding);
    }];
    
    //商品类别视图
    UIView *categoryView = [[UIView alloc] init];
    categoryView.backgroundColor = COLOR_MAIN_WHITE;
    categoryView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    categoryView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:categoryView];
    
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@65);
        
    }];
    
    //商品类别
    UILabel *categoryLabel = [[UILabel alloc] init];
    categoryLabel.text = @"商品类别";
    categoryLabel.textColor = COLOR_MAIN_BLACK;
    categoryLabel.font = FONT_MAIN;
    [categoryView addSubview:categoryLabel];
    
    [categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(categoryView.mas_left).offset(padding);
        make.top.equalTo(categoryView.mas_top).offset(paddingTop);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    //商品类别选择按钮
    categoryBtn = [[UIButton alloc] init];
    categoryBtn.layer.borderWidth = 0.5f;
    categoryBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    categoryBtn.layer.cornerRadius = 3.0f;
    categoryBtn.titleLabel.font = FONT_MAIN;
    [categoryBtn addTarget:self action:@selector(actionChooseCategory) forControlEvents:UIControlEventTouchUpInside];
    [categoryBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [categoryBtn setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [self.contentView addSubview:categoryBtn];
    
    [categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(categoryView.mas_bottom).offset(-paddingTop);
        make.left.equalTo(categoryView.mas_left).offset(padding);
        make.width.equalTo(@120);
        make.height.equalTo(@25);
    }];
    
    
    //品牌型号视图
    UIView *brandModelView = [[UIView alloc] init];
    brandModelView.backgroundColor = COLOR_MAIN_WHITE;
    brandModelView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    brandModelView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:brandModelView];
    
    [brandModelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(categoryView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@65);
        
    }];
    //品牌型号
    UILabel *brandModelLabel = [[UILabel alloc] init];
    brandModelLabel.text = @"品牌型号";
    brandModelLabel.textColor = COLOR_MAIN_BLACK;
    brandModelLabel.font = FONT_MAIN;
    [brandModelView addSubview:brandModelLabel];
    
    [brandModelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(brandModelView.mas_left).offset(padding);
        make.top.equalTo(brandModelView.mas_top).offset(paddingTop);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    
    //品牌按钮
    self.brandButton = [[UIButton alloc] init];
    self.brandButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    self.brandButton.layer.borderWidth = 0.5f;
    self.brandButton.layer.cornerRadius = 3.0f;
    self.brandButton.titleLabel.font = FONT_MAIN;
    self.brandButton.enabled = NO;
    [self.brandButton addTarget:self action:@selector(actionChooseBrand) forControlEvents:UIControlEventTouchUpInside];
    [self.brandButton setTitle:@"请选择" forState:UIControlStateNormal];
    [self.brandButton setTitleColor:COLOR_MAIN_GRAY forState:UIControlStateDisabled];
    [self.contentView addSubview:self.brandButton];
    
    [self.brandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(brandModelView.mas_bottom).offset(-paddingTop);
        make.left.equalTo(brandModelView.mas_left).offset(padding);
        make.width.equalTo(@120);
        make.height.equalTo(@25);
    }];
    //型号
    self.modelButton = [[UIButton alloc] init];
    self.modelButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    self.modelButton.layer.borderWidth = 0.5f;
    self.modelButton.layer.cornerRadius = 3.0f;
    self.modelButton.enabled = NO;
    self.modelButton.titleLabel.font = FONT_MAIN;
    [self.modelButton addTarget:self action:@selector(actionChooseModel) forControlEvents:UIControlEventTouchUpInside];
    [self.modelButton setTitle:@"请选择" forState:UIControlStateNormal];
    [self.modelButton setTitleColor:COLOR_MAIN_GRAY forState:UIControlStateDisabled];
    [self.contentView addSubview:self.modelButton];
    
    [self.modelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(brandModelView.mas_bottom).offset(-paddingTop);
        make.left.equalTo(self.brandButton.mas_right).offset(padding);
        make.width.equalTo(@120);
        make.height.equalTo(@25);
    }];
    
    
    //规格视图
    specView = [[UIView alloc] init];
    specView.backgroundColor = COLOR_MAIN_WHITE;
    specView.layer.borderWidth = 0.5f;
    specView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [self.contentView addSubview:specView];
    
    [specView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brandModelView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@60);
    }];
    tipSpecLabel = [[UILabel alloc] init];
    tipSpecLabel.text = @"请先选择品牌型号";
    tipSpecLabel.textColor = COLOR_MAIN_GRAY;
    tipSpecLabel.font = FONT_MAIN;
    [specView addSubview:tipSpecLabel];
    
    [tipSpecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(specView.mas_left).offset(padding);
        make.centerY.equalTo(specView.mas_centerY);
    }];
    
    
    //单价视图
    UIView *priceView = [[UIView alloc] init];
    priceView.backgroundColor = COLOR_MAIN_WHITE;
    priceView.layer.borderWidth = 0.5f;
    priceView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [self.contentView addSubview:priceView];
    
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(specView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@40);
    }];
    //单价名称
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"单价";
    priceLabel.font = FONT_MAIN;
    [priceView addSubview:priceLabel];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceView.mas_centerY);
        make.left.equalTo(priceView.mas_left).offset(padding);
    }];
    //单价
    goodsPrice = [[UILabel alloc] init];
    goodsPrice.text = @"￥0";
    goodsPrice.textColor = [UIColor redColor];
    goodsPrice.font = FONT_MAIN;
    [priceView addSubview:goodsPrice];
    
    [goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceView.mas_centerY);
        make.right.equalTo(priceView.mas_right).offset(-padding);
    }];

    //购买数量视图
    UIView *numberView = [[UIView alloc] init];
    numberView.backgroundColor = COLOR_MAIN_WHITE;
    numberView.layer.borderWidth = 0.5f;
    numberView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [self.contentView addSubview:numberView];
    
    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@40);
    }];
    //购买数量名称
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.text = @"购买数量";
    numberLabel.font = FONT_MAIN;
    [numberView addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numberView.mas_centerY);
        make.left.equalTo(numberView.mas_left).offset(padding);
    }];
    
    //加数量按钮
    UIButton *numberPlus = [[UIButton alloc] init];
    numberPlus.layer.borderWidth = 0.5f;
    numberPlus.layer.borderColor = CGCOLOR_MAIN_BORDER;
    numberPlus.backgroundColor = [UIColor clearColor];
    numberPlus.titleLabel.font = FONT_MAIN;
    numberPlus.titleLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    [numberPlus addTarget:self action:@selector(actionGoodsNumberPlus) forControlEvents:UIControlEventTouchUpInside];
    [numberPlus setTitle:@"+" forState:UIControlStateNormal];
    [numberPlus setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [numberView addSubview:numberPlus];
    
    [numberPlus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(numberView.mas_right).offset(-padding);
        make.top.equalTo(numberView.mas_top).offset(5);
        make.width.equalTo(@25);
        make.height.equalTo(@30);
    }];
    //数量输入框
    goodsNumber = [[UILabel alloc] init];
    goodsNumber.text = @"1";
    goodsNumber.font = FONT_MAIN;
    goodsNumber.backgroundColor = [UIColor clearColor];
    goodsNumber.layer.borderColor = CGCOLOR_MAIN_BORDER;
    goodsNumber.layer.borderWidth = 0.5f;
    goodsNumber.textAlignment = NSTextAlignmentCenter;
    [numberView addSubview:goodsNumber];
    
    [goodsNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(numberPlus.mas_left).offset(-5);
        make.top.equalTo(numberView.mas_top).offset(5);
        make.width.equalTo(@40);
        make.height.equalTo(@30);
    }];
    //减少数量
    UIButton *numberMinus = [[UIButton alloc] init];
    numberMinus.layer.borderWidth = 0.5f;
    numberMinus.layer.borderColor = CGCOLOR_MAIN_BORDER;
    numberMinus.backgroundColor = [UIColor clearColor];
    numberMinus.titleLabel.font = FONT_MAIN;
    numberMinus.titleLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    [numberMinus addTarget:self action:@selector(actionGoodsNumberMinus) forControlEvents:UIControlEventTouchUpInside];
    [numberMinus setTitle:@"-" forState:UIControlStateNormal];
    [numberMinus setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [numberView addSubview:numberMinus];
    
    [numberMinus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberView.mas_top).offset(5);
        make.right.equalTo(goodsNumber.mas_left).offset(-5);
        make.width.equalTo(@25);
        make.height.equalTo(@30);
    }];
    
    //保存
    UIButton *button = [AppUIUtil makeButton:@"保存"];
    [button addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    height = 50 + 65 * 2 + 60 + 40 * 2 + 45 + 8 * 10;
    self.contentSize = CGSizeMake(SCREEN_WIDTH, height);
    return self;
}

- (void)specBox
{
    NSMutableArray *specList = [self fetch:@"spexBox"];
    specCount = specList.count;
    selectCount = 0;
    //移除之前的规格
    for (UIView *view in specListView.subviews) {
        [view removeFromSuperview];
    }
    if (specList.count < 1) {
        tipSpecLabel.hidden = NO;
        [specView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];
        self.contentSize = CGSizeMake(SCREEN_WIDTH, height);
    } else {
        tipSpecLabel.hidden = YES;
        CGFloat heightNew = height + (specCount - 1) * 60;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, heightNew);
        
        //更新规格视图高度
        CGFloat specHeight = specList.count * 60;
        [specView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(specHeight));
        }];
        
        specListView = [[UIView alloc] init];
        [specView addSubview:specListView];
        [specListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(specView.mas_top);
            make.left.equalTo(specView.mas_left);
            make.right.equalTo(specView.mas_right);
            make.bottom.equalTo(specView.mas_bottom);
        }];
        
        //分隔条
        UIView *relateView = [[UIView alloc] init];
        [specListView addSubview:relateView];
        
        [relateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(specListView.mas_top);
            make.left.equalTo(specListView.mas_left);
            make.right.equalTo(specListView.mas_right);
        }];
        
        NSInteger i = 1;
        buttons = [[NSMutableArray alloc] init];
        for (NSDictionary *specS in specList){
            NSLog(@"规格是：%@",specS[@"name"]);
            UIView *specBoxView = [[UIView alloc] init];
            [specListView addSubview:specBoxView];
            
            [specBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(relateView.mas_bottom);
                make.left.equalTo(specView.mas_left);
                make.right.equalTo(specView.mas_right);
                make.height.equalTo(@60);
            }];
            //规格名称
            UILabel *specLabel = [[UILabel alloc] init];
            specLabel.text = specS[@"name"];
            specLabel.textColor = COLOR_MAIN_BLACK;
            specLabel.font = FONT_MAIN;
            [specBoxView addSubview:specLabel];
            
            [specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(specBoxView.mas_top).offset(paddingTop);
                make.left.equalTo(relateView.mas_left).offset(padding);
                make.height.equalTo(@20);
            }];
        
            //详细规则滚动视图
            UIScrollView *specBtnBox = [[UIScrollView alloc] init];
            specBtnBox.delegate = self;
            //启用滚动
            specBtnBox.scrollEnabled = YES;
            //接受触摸事件
            specBtnBox.userInteractionEnabled = YES;
            //隐藏垂直滚动条
            specBtnBox.showsVerticalScrollIndicator = NO;
            specBtnBox.showsHorizontalScrollIndicator = NO;
            [specBtnBox setPagingEnabled:NO];
            [specBoxView addSubview:specBtnBox];
            
            [specBtnBox mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(specBoxView.mas_left);
                make.right.equalTo(specBoxView.mas_right);
                make.bottom.equalTo(specBoxView.mas_bottom);
                make.top.equalTo(specLabel.mas_bottom);
            }];
            CGFloat scrollWidth = 0;
            x = 10;
            space = 5;
        
            //详细规格按钮
            for (SpecEntity *specEntity in specS[@"list"]) {
                NSLog(@"详细规格有：%@",specEntity.name);
                UIButton *specBtn = [[UIButton alloc] init];
                specBtn.backgroundColor = [UIColor clearColor];
                specBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
                specBtn.layer.borderWidth = 0.5f;
                specBtn.layer.cornerRadius = 3.0f;
                specBtn.titleLabel.font = FONT_MAIN;
                [specBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
                [specBtn addTarget:self action:@selector(actionSpec:) forControlEvents:UIControlEventTouchUpInside];
                [specBtn setTitle:specEntity.name forState:UIControlStateNormal];
                [specBtn setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
                [specBtn.titleLabel sizeToFit];

                //根据文字宽度计算按钮宽度
                CGSize labelSize = specBtn.titleLabel.frame.size;
                CGFloat width = (labelSize.width > 40 ? labelSize.width : 40) + 10;

                //添加specId数据绑定，先用tag绑定，后续可以考虑UIButton附加动态数据
                specBtn.tag = [specEntity.id integerValue];
                specBtn.accessibilityIdentifier = [NSString stringWithFormat:@"%ld",i];
                [specBtnBox addSubview:specBtn];
                [buttons addObject:specBtn];

                [specBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(specBtnBox.mas_centerY);
                    make.left.equalTo(specBtnBox.mas_left).offset(x);
                    make.height.equalTo(@25);
                    make.width.equalTo(@(width));
                }];
                
                x += width + space;
                scrollWidth += width;
            }
            scrollWidth = [specS[@"list"] count] * space + scrollWidth + 15;

            specBtnBox.contentSize = CGSizeMake(scrollWidth, 0);
            //分隔条
            if (i != specList.count) {
                UIView *borderView = [[UIView alloc] init];
                borderView.layer.borderColor = CGCOLOR_MAIN_BORDER;
                borderView.layer.borderWidth = 0.5f;
                [specListView addSubview:borderView];
                
                [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(specBoxView.mas_bottom);
                    make.left.equalTo(specView.mas_left);
                    make.right.equalTo(specView.mas_right);
                    make.height.equalTo(@0.5);
                }];
            }
            i++;

            relateView = specBoxView;
        }
    }
}

//设置头部需求信息
- (void)setCaseNo
{
    CaseEntity *caseEntity = [self fetch:@"caseEntity"];
    caseNo.text = caseEntity.no;
    statusName.text = [caseEntity statusName];
}

//选择规格
- (void) actionSpec: (UIButton *) sender
{
    //取消其它所有选中
    specSelectedData = [[NSMutableArray alloc] init];
    for (UIButton *button in buttons) {
        if ([sender.accessibilityIdentifier isEqualToString:button.accessibilityIdentifier]){
            button.backgroundColor = COLOR_MAIN_WHITE;
            [button setAccessibilityValue:@""];
        }
    }
    
    //选中当前并保存选中值
    sender.backgroundColor = COLOR_MAIN_HIGHLIGHT;
    [sender setAccessibilityValue:@"selected"];
    for (UIButton *button in buttons) {
        if ([button.accessibilityValue isEqualToString:@"selected"]){
            [specSelectedData addObject:@(button.tag)];
            selectCount++;
        }
    }
    if (specSelectedData.count == specCount) {
        [self.delegate actionChooseSpec:specSelectedData];
    }

}

//选择商品类型
- (void)actionChooseCategory
{
    [self.delegate actionChooseCategory:categoryBtn];
}

//选择品牌
- (void)actionChooseBrand
{
    [self.delegate actionChooseBrand:self.brandButton];
}

//选择型号
- (void)actionChooseModel
{
    [self.delegate actionChooseModel:self.modelButton];
}

//添加购买数量
- (void)actionGoodsNumberPlus
{
    NSInteger number = [self getGoodsNumber];
    number++;
    goodsNumber.text = [NSString stringWithFormat:@"%ld", number];
    
}

//获取商品数量
- (NSInteger) getGoodsNumber
{
    NSString *numberStr = [goodsNumber.text trim];
    NSInteger number = [numberStr length] > 0 ? [numberStr integerValue] : 1;
    return number;
}

//减少商品数量
- (void)actionGoodsNumberMinus
{
    NSInteger number = [self getGoodsNumber];
    number--;
    if (number < 1) number = 1;
    goodsNumber.text = [NSString stringWithFormat:@"%ld", number];
}

//保存商品
- (void)actionSave
{
    NSInteger number = [self getGoodsNumber];
    [self.delegate actionSave:number];
}

//设置商品单价
- (void)setGoodsPrice:(NSString *)price
{
    goodsPrice.text = price;
}

@end
