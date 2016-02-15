//
//  FWXmlViewController.m
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWXmlViewController.h"
#import "BaseXmlView.h"

@interface FWXmlViewController ()

@end

@implementation FWXmlViewController
{
    NSString *_xmlName;
}

- (void)loadView
{
    //未设置Xml名称
    if (!self.xmlName) {
        [super loadView];
        return;
    }
    
    self.view = [BaseXmlView viewWithName:self.xmlName callback:^(BaseXmlView *view) {
        if (view) {
            //关联控制器
            view.viewController = self;
            
            [self xmlViewLoaded];
        } else {
            [self xmlViewFailed];
        }
    }];
}

- (NSString *)xmlName
{
    if (!_xmlName) {
        NSString *className = NSStringFromClass([self class]);
        if (![@"FWXmlViewController" isEqualToString:className]) {
            _xmlName = [className stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];
        }
    }
    return _xmlName;
}

- (void)setXmlName:(NSString *)xmlName
{
    _xmlName = xmlName;
}

- (void)xmlViewLoaded
{
    
}

- (void)xmlViewFailed
{
    
}

@end
