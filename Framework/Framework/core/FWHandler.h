//
//  FWHandler.h
//  Framework
//
//  Created by wuyong on 16/2/23.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FWHandlerBlock)(id object);

#pragma mark -
@interface FWHandler : NSObject

- (BOOL)trigger:(NSString *)name;
- (BOOL)trigger:(NSString *)name withObject:(id)object;

- (BOOL)hasBlock:(NSString *)name;
- (void)setBlock:(NSString *)name block:(FWHandlerBlock)block;
- (void)removeBlock:(NSString *)name;
- (void)clearBlocks;

@end

#pragma mark -
@interface NSObject (FWHandler)

- (FWHandler *)blockHandler;

@end
