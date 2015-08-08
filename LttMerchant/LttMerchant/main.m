//
//  main.m
//  LttMerchant
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LttAppDelegate.h"

#import "Samurai.h"
#import "Samurai_WebCore.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        if (IS_DEBUG) {
            [[SamuraiWatcher sharedInstance] watch:@(__FILE__)];
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([LttAppDelegate class]));
    }
}
