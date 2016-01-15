//
//  CaseEditView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseEditViewDelegate <NSObject>

- (void)actionSave:(NSString *)remark;

@end

@interface CaseEditView : AppView

@property (retain , nonatomic) id<CaseEditViewDelegate>delegate;

@end
