//
//  DebugUtil.h
//  LttMember
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DebugUtilDelegate <NSObject>

@optional
- (void)sourceFileChanged:(NSString *)filePath;
- (void)sourceFileDeleted:(NSString *)filePath;
- (void)urlResponseChanged:(NSString *)url;
- (void)urlResponseError:(NSString *)url;

@end

@interface DebugUtil : NSObject

@prop_weak(id<DebugUtilDelegate>, delegate)

+ (DebugUtil *) sharedInstance;

//监听代码文件改变，全局设置，仅模拟器有效
- (void) watchPath:(NSString *)path exts:(NSArray *)exts;

//设置监听URL刷新间隔，0为默认，负数不监听
- (void) watchUrlInterval:(NSTimeInterval)interval;

//监听某个URL内容改变，仅调试模式有效
- (void) watchUrlStart:(NSString *)url;

//停止监听某个试图，仅调试模式有效
- (void) watchUrlEnd:(NSString *)url;

//标记开始
- (void) benchmarkStart:(NSString *)name;

//标记结束
- (void) benchmarkEnd:(NSString *)name;

//显示调试工具
- (void) showFlex;

//隐藏调试工具
- (void) hideFlex;

//切换调试工具
- (void) toggleFlex;

@end
