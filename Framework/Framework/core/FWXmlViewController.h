//
//  FWXmlViewController.h
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWViewController.h"

@interface FWXmlViewController : FWViewController

@prop_strong(NSString *, xmlName)

//视图加载完成钩子，子类重写，事件绑定需在页面加载完成后
- (void)xmlViewLoaded;

//视图加载失败钩子，子类重写
- (void)xmlViewFailed;

@end
