//
//  BusinessEntity.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessEntity.h"
#import "UIImageView+WebCache.h"

@implementation BusinessEntity

@synthesize caseId;

@synthesize newsId;

@synthesize id;

@synthesize merchantId;

@synthesize merchantName;

@synthesize newsContent;

@synthesize newsImgs;

@synthesize createTime;


- (void)uploadPicView:(UIImageView *)view imgUrl:(NSString *)imgUrl
{
    if (imgUrl && [imgUrl length] > 0) {
        
        [view sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@""]];
    } else {
        view.image = [UIImage imageNamed:@""];
    }

}

@end
