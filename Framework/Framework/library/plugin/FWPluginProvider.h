//
//  FWPluginProvider.h
//  Framework
//
//  Created by 吴勇 on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//插件提供者协议
@protocol FWPluginProvider <NSObject>

- (id)providePlugin:(NSString *)name;

@end
