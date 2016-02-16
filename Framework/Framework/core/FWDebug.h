//
//  FWDebug.h
//  Framework
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FWDebugDelegate <NSObject>

@optional
- (void)sourceFileChanged:(NSString *)filePath;
- (void)sourceFileDeleted:(NSString *)filePath;
- (void)urlResponseChanged:(NSString *)url;
- (void)urlResponseError:(NSString *)url;

@end

@interface FWDebug : NSObject

@prop_weak(id<FWDebugDelegate>, delegate)

+ (FWDebug *) sharedInstance;

//监听代码文件改变，全局设置，仅模拟器有效
- (void) watchPath:(NSString *)path exts:(NSArray *)exts;

//监听某个URL内容改变，仅调试模式有效
- (void) watchUrlStart:(NSString *)url;

//停止监听某个试图，仅调试模式有效
- (void) watchUrlEnd:(NSString *)url;

//标记开始
- (void) benchmarkStart:(NSString *)name;

//标记结束
- (void) benchmarkEnd:(NSString *)name;

@end
