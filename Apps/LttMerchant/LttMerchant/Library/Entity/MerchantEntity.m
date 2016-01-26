//
//  MerchantEntity.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "MerchantEntity.h"
#import "UIImageView+WebCache.h"

@implementation MerchantEntity

@synthesize contacter,contacter_id,merchant_address,merchant_name,licenseUrl,cardUrl,province,city,area,street;

- (void) imageView:(UIImageView *)view
{
    if (self.avatar && [self.avatar length] > 0) {
        NSLog(@"加载图片缓存：%@", self.avatar);
        [view sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:nil];
    } else {
        view.image = nil;
    }
}

@end
