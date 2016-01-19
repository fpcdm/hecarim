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
    NSMutableDictionary *watchUrls;
    NSTimeInterval urlInterval;
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
                                           NSLog(@"sourceFileChanged:%@", filePath);
                                           [self.delegate sourceFileChanged:filePath];
                                       }
                                   } else {
                                       if (self.delegate && [self.delegate respondsToSelector:@selector(sourceFileDeleted:)]) {
                                           NSLog(@"sourceFileDeleted:%@", filePath);
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

- (void)watchUrlInterval:(NSTimeInterval)interval
{
#ifdef APP_DEBUG
    urlInterval = interval;
#endif
}

- (void)watchUrlStart:(NSString *)url
{
#ifdef APP_DEBUG
    if (!watchUrls) watchUrls = [[NSMutableDictionary alloc] init];
    
    //标记监听
    if (![watchUrls objectForKey:url]) {
        [watchUrls setObject:@"" forKey:url];
    }
    
    NSLog(@"watchUrlStart:%@", url);
    [self watchUrlResponse:url];
#endif
}

- (void)watchUrlEnd:(NSString *)url
{
#ifdef APP_DEBUG
    //移除监听
    if (watchUrls && [watchUrls objectForKey:url]) {
        [watchUrls removeObjectForKey:url];
    }
    
    NSLog(@"watchUrlEnd:%@", url);
#endif
}

#ifdef APP_DEBUG
- (void)watchUrlResponse:(NSString *)url
{
    //检查刷新间隔
    if (urlInterval == 0) urlInterval = DEBUG_WATCHURL_INTERVAL;
    if (urlInterval <= 0) return;
    
    //是否开启URL监听
    NSString *oldHash = watchUrls ? [watchUrls objectForKey:url] : nil;
    if (!oldHash) return;
    
    //开始解析
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *urlResp, NSData *data, NSError *error){
        //获取状态码
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)urlResp;
        NSInteger statusCode = httpResp.statusCode;
        
        //响应正常
        if (statusCode == 200 && !error) {
            NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *newHash = [EncodeUtil md5:response];
            
            //判断是否响应改变
            BOOL hashChanged = oldHash.length > 0 && ![oldHash isEqualToString:newHash];
            [watchUrls setObject:newHash forKey:url];
            if (hashChanged) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(urlResponseChanged:)]) {
                    NSLog(@"urlResponseChanged:%@", url);
                    [self.delegate urlResponseChanged:url];
                }
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(urlResponseError:)]) {
                NSLog(@"urlResponseError:%@", url);
                [self.delegate urlResponseError:url];
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
