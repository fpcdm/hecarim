//
//  FWNetwork.h
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FWRequestProtocol <NSObject>

@end

@interface FWRequest : NSObject<FWRequestProtocol>

@singleton(FWRequest)

@end
