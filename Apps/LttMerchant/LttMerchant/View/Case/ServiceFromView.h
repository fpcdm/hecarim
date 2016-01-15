//
//  ServiceFromView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"
#import "ServiceEntity.h"

@protocol ServiceFromViewDelegate <NSObject>

- (void)actionSave:(NSString *)remark price:(NSString *)price;

@end

@interface ServiceFromView : AppView

@property (retain ,nonatomic) id<ServiceFromViewDelegate>delegate;

@end
