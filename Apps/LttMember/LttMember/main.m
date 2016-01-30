//
//  main.m
//  LttMember
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LttAppDelegate.h"
#import "FWDebug.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
#if TARGET_IPHONE_SIMULATOR
        //监听视图改变
        [[FWDebug sharedInstance] watchPath:@(__FILE__) exts:nil];
#endif
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([LttAppDelegate class]));
    }
}
