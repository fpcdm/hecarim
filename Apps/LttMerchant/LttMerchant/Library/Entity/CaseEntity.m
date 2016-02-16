//
//  CaseEntity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseEntity.h"
#import "GoodsEntity.h"
#import "ServiceEntity.h"
#import "UIImageView+WebCache.h"

@implementation CaseEntity

@synthesize id, no, status, createTime, mapUrl, rateStar, typeId, typeName, propertyId, propertyName,
            buyerName, buyerMobile, buyerAddress, customerRemark,
            staffId, staffName, staffMobile, staffAvatar, staffRemark,
            userId, userName, userMobile, userAvatar, userAppellation,
            isOnlinePay, payWay, qrcodeUrl,
            totalAmount, goodsAmount, servicesAmount, goods, services, goodsParam, servicesParam;

- (NSString *)statusName
{
    NSDictionary *names = @{
                            CASE_STATUS_NEW:@"派单中",
                            CASE_STATUS_LOCKED:@"已派单",
                            CASE_STATUS_CONFIRMED:@"服务中",
                            CASE_STATUS_TOPAY:@"未付款",
                            CASE_STATUS_PAYED:@"已付款",
                            CASE_STATUS_SUCCESS:@"已完成",
                            CASE_STATUS_MEMBER_CANCEL:@"已取消",
                            CASE_STATUS_MERCHANT_CANCEL:@"已取消"
                            };
    
    NSString *name = [names objectForKey:self.status];
    return name ? name : @"状态错误";
}

- (UIColor *)statusColor
{
    if ([CASE_STATUS_NEW isEqualToString:self.status]) {
        return [UIColor colorWithHexString:@"FFA54D"];
    } else if ([CASE_STATUS_LOCKED isEqualToString:self.status]) {
        return [UIColor colorWithHexString:@"FFA54D"];
    } else if ([CASE_STATUS_CONFIRMED isEqualToString:self.status]) {
        return [UIColor colorWithHexString:@"FFA54D"];
    } else if ([CASE_STATUS_TOPAY isEqualToString:self.status]) {
        return [UIColor redColor];
    } else if ([CASE_STATUS_PAYED isEqualToString:self.status]) {
        return [UIColor colorWithHexString:@"4DD14D"];
    } else if ([CASE_STATUS_SUCCESS isEqualToString:self.status]) {
        return [UIColor colorWithHexString:@"4DD14D"];
    } else {
        return [UIColor lightGrayColor];
    }
}

- (BOOL) isFail
{
    return [CASE_STATUS_MEMBER_CANCEL isEqualToString:self.status] || [CASE_STATUS_MERCHANT_CANCEL isEqualToString:self.status];
}

- (void) qrcodeImageView:(UIImageView *)imageView way:(NSString *)way failure:(void (^)())failure
{
    //参数检查
    if (!way || !self.qrcodeUrl || [self.qrcodeUrl length] < 1) {
        imageView.image = nil;
        return;
    }
    
    //替换字符
    NSString *imageUrl = [self.qrcodeUrl stringByReplacingOccurrencesOfString:@"*#pay_way#*" withString:way];
    NSLog(@"二维码图片地址：%@", imageUrl);
    
    //增加随机字符串防止图片缓存
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    imageUrl = [NSString stringWithFormat:@"%@&t=%@", imageUrl, [dateFormat stringFromDate:[NSDate date]]];
    
    [imageView showIndicator];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                 placeholderImage:nil
                          options:SDWebImageRefreshCached
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            [imageView hideIndicator];
                            
                            //是否加载错误
                            if (error) {
                                failure();
                            }
                          }];
}

- (NSDictionary *) formatFormGoods
{
    NSMutableDictionary *goodsParam = [[NSMutableDictionary alloc] init];
    NSInteger index = 0;
    
    //添加商品：为了解决nsarray不传key的问题，使用nsdictionary
    for (GoodsEntity *entity in self.goods) {
        NSDictionary *goodsDict = @{
                                    @"goods_id": entity.id,
                                    @"goods_num": entity.number,
                                    @"price_id": entity.priceId
                                    };
        
        [goodsParam setObject:goodsDict forKey:[NSString stringWithFormat:@"%ld", index]];
        index++;
    }
    
    return goodsParam;
}

- (NSDictionary *) formatFormServices
{
    NSMutableDictionary *servicesParam = [[NSMutableDictionary alloc] init];
    NSInteger index = 0;
    
    //添加服务：为了解决nsarray不传key的问题，使用nsdictionary
    for (ServiceEntity *entity in self.services) {
        NSDictionary *serviceDict = @{
                                    @"category_id": entity.typeId,
                                    @"content": entity.name,
                                    @"price": entity.price
                                    };
        
        [servicesParam setObject:serviceDict forKey:[NSString stringWithFormat:@"%ld", index]];
        index++;
    }
    
    return servicesParam;
}

@end
