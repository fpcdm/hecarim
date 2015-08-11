//
//  ServiceListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceListActivity.h"
#import "ServiceFormActivity.h"

@interface ServiceListActivity ()

@property (nonatomic, strong) UITableView *listTable;

@end

@implementation ServiceListActivity
{
    //返回页面是否需要刷新
    BOOL needRefresh;
}

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    //第一次需要刷新
    needRefresh = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (needRefresh) {
        needRefresh = NO;
        [self loadCase];
    }
}

- (NSString *)templateName
{
    return @"serviceList.html";
}

#pragma mark - Template
- (void) onTemplateLoaded
{
    //动态计算表格高度
    float tableHeight = SCREEN_AVAILABLE_HEIGHT - 110;
    $(@"#listTable").ATTR(@"height", [NSString stringWithFormat:@"%lfpx", tableHeight]);
}

#pragma mark - reloadData
- (void) reloadData
{
    [super reloadData];
    
    NSInteger servicesCount = intention.services ? [intention.services count] : 0;
    self.scope[@"list"] = @{
                                      
                                      @"services": ({
                                          NSMutableArray *servicesList = [NSMutableArray array];
                                          
                                          if (servicesCount > 0) {
                                              for (ServiceEntity *service in intention.services) {
                                                  [servicesList addObject:@{
                                                                            @"name": service.typeName,
                                                                            @"price": [NSString stringWithFormat:@"￥%@", service.price]
                                                                            }];
                                              }
                                          }
                                          
                                          servicesList;
                                          
                                      })};
    
    [self.listTable reloadData];
    
    //重新布局
    [self relayout];
}

#pragma mark - Action
- (void) actionAddService: (SamuraiSignal *) signal
{
    ServiceFormActivity *activity = [[ServiceFormActivity alloc] init];
    activity.caseId = self.caseId;
    activity.callbackBlock = ^(id object){
        //标记可刷新
        if (object && [@1 isEqualToNumber:object]) {
            needRefresh = YES;
            
            //标记父级可刷新
            if (self.callbackBlock) {
                self.callbackBlock(object);
            }
        }
    };
    [self pushViewController:activity animated:YES];
}

@end
