//
//  DebugUtil.m
//  LttMember
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "DebugUtil.h"
#import "FrameworkConfig.h"

#ifdef APP_DEBUG
#import "FLEX.h"

#import <sys/sysctl.h>
#import <mach/mach.h>

#import "EncodeUtil.h"
#define DEBUGUTIL
#endif

static DebugUtil *sharedInstance = nil;

@implementation DebugUtil
{
    NSMutableDictionary *benchmarks;
    NSMutableDictionary *memorys;

#ifdef APP_DEBUG
#if TARGET_IPHONE_SIMULATOR
    NSString *sourcePath;
    NSArray *sourceExts;
    NSMutableArray *sourceFiles;
#endif
#endif
    
#ifdef APP_DEBUG
    NSString *urlPath;
    NSString *urlHash;
    NSTimeInterval urlInterval;
    BOOL urlUnwatch;
#endif
}

+ (DebugUtil *) sharedInstance
{
    //多线程唯一
    @synchronized(self){
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        benchmarks = [[NSMutableDictionary alloc] init];
        memorys = [[NSMutableDictionary alloc] init];
#ifdef APP_DEBUG
        [[FLEXManager sharedManager] setNetworkDebuggingEnabled:YES];
#endif
    }
    return self;
}

- (void)watchPath:(NSString *)path exts:(NSArray *)exts
{
#ifdef APP_DEBUG
#if TARGET_IPHONE_SIMULATOR
    sourcePath = [[NSString stringWithFormat:@"%@/../", path] stringByStandardizingPath];
    if (exts) {
        sourceExts = exts;
    } else {
        //默认监听模板文件
        sourceExts = @[@"xml", @"html", @"htm", @"css", @"tpl"];
    }
    [self scanSourceFiles];
#endif
#endif
}

#ifdef APP_DEBUG
#if TARGET_IPHONE_SIMULATOR
- (void)scanSourceFiles
{
    if (sourceFiles == nil) sourceFiles = [[NSMutableArray alloc] init];
    
    [sourceFiles removeAllObjects];
    
    NSString * basePath = [[sourcePath stringByStandardizingPath] copy];
    if (nil == basePath) return;
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:basePath];
    if (enumerator) {
        for (;;) {
            NSString *filePath = [enumerator nextObject];
            if (nil == filePath) break;
            
            NSString *fileName = [filePath lastPathComponent];
            NSString *fileExt = [fileName pathExtension];
            NSString *fullPath = [basePath stringByAppendingPathComponent:filePath];
            
            BOOL isDirectory = NO;
            BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
            if (exists && NO == isDirectory) {
                BOOL isValid = NO;
                
                for (NSString *extension in sourceExts) {
                    if (NSOrderedSame == [fileExt compare:extension]) {
                        isValid = YES;
                        break;
                    }
                }
                
                if (isValid) {
                    [sourceFiles addObject:fullPath];
                }
            }
        }
    }
    
    for (NSString *filePath in sourceFiles) {
        [self watchSourceFile:filePath];
    }
}

- (void)watchSourceFile:(NSString *)filePath
{
    int fileHandle = open([filePath UTF8String], O_EVTONLY);
    if (fileHandle) {
        unsigned long mask = DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND;
        __block dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __block dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fileHandle, mask, queue);
        
        @weakify(self)
        __block id eventHandler = ^{
            @strongify(self)
            
            unsigned long flags = dispatch_source_get_data(source);
            if (flags) {
                dispatch_source_cancel(source);
                dispatch_async(dispatch_get_main_queue(), ^{
                                   BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NULL];
                                   if (exists) {
                                       if (self.delegate && [self.delegate respondsToSelector:@selector(sourceFileChanged:)]) {
                                           [self.delegate sourceFileChanged:filePath];
                                       }
                                   } else {
                                       if (self.delegate && [self.delegate respondsToSelector:@selector(sourceFileDeleted:)]) {
                                           [self.delegate sourceFileDeleted:filePath];
                                       }
                                   }
                               });
                [self watchSourceFile:filePath];
            }
        };
        
        __block id cancelHandler = ^{
            close(fileHandle);
        };
        
        dispatch_source_set_event_handler(source, eventHandler);
        dispatch_source_set_cancel_handler(source, cancelHandler);
        dispatch_resume(source);
    }
}
#endif
#endif

- (void)watchUrl:(NSString *)url interval:(NSTimeInterval)interval
{
#ifdef APP_DEBUG
    urlUnwatch = NO;
    
    //判断Url是否改变
    if (interval > 0) {
        urlInterval = interval;
    } else if (urlInterval <= 0) {
        urlInterval = DEBUG_WATCHURL_INTERVAL;
    }
    
    [self watchUrlResponse:url];
#endif
}

- (void)unwatchUrl
{
#ifdef APP_DEBUG
    urlUnwatch = YES;
#endif
}

#ifdef APP_DEBUG
- (void)watchUrlResponse:(NSString *)url
{
    //是否停止监听
    if (urlUnwatch) return;
    
    //开始解析
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *urlresp, NSData *data, NSError *error){
        //响应错误
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(urlResponseError:)]) {
                [self.delegate urlResponseError:url];
            }
        } else {
            NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *newHash = [EncodeUtil md5:response];
            //响应改变
            BOOL hashChanged = NO;
            if (urlPath && [urlPath isEqualToString:url] &&
                urlHash && ![urlHash isEqualToString:newHash]) {
                hashChanged = YES;
            }
            
            urlHash = newHash;
            urlPath = url;
            if (hashChanged) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(urlResponseChanged:)]) {
                    [self.delegate urlResponseChanged:url];
                }
            }
        }
        
        //执行轮询
        [self performSelector:@selector(watchUrlResponse:) withObject:url afterDelay:urlInterval];
    }];
}
#endif

#ifdef APP_DEBUG
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}
#endif

- (void)benchmarkStart:(NSString *)name
{
#ifdef APP_DEBUG
    NSDate *now = [NSDate date];
    benchmarks[name] = now;
    
    double memory = [self usedMemory];
    if (memory == NSNotFound) memory = 0;
    memorys[name] = @(memory);
    
    NSLog(@"BENCHMARK-START-%@: %.3fs %.3fMB", name, [now timeIntervalSince1970], memory);
#endif
}

- (void)benchmarkEnd:(NSString *)name
{
#ifdef APP_DEBUG
    NSDate *now = [NSDate date];
    
    double memory = [self usedMemory];
    if (memory == NSNotFound) memory = 0;
    
    NSLog(@"BENCHMARK-END-%@: %.3fs %.3fMB", name, [now timeIntervalSince1970], memory);
    
    NSDate *timeStart = [benchmarks objectForKey:name];
    if (!timeStart) return;
    NSNumber *memoryStart = [memorys objectForKey:name];
    
    //获取间隔
    float timeInterval = [now timeIntervalSince1970] - [timeStart timeIntervalSince1970];
    double memoryInterval = memory - [memoryStart doubleValue];
    NSLog(@"BENCHMARK-INFO-%@: %.3fs %.3fMB", name, timeInterval, memoryInterval);
#endif
}

- (void)showFlex
{
#ifdef APP_DEBUG
    [[FLEXManager sharedManager] showExplorer];
#endif
}

- (void)hideFlex
{
#ifdef APP_DEBUG
    [[FLEXManager sharedManager] hideExplorer];
#endif
}

- (void)toggleFlex
{
#ifdef APP_DEBUG
    [[FLEXManager sharedManager] toggleExplorer];
#endif
}

@end
