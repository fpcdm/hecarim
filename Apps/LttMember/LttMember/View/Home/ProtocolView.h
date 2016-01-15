//
//  ProtocolView.h
//  LttMember
//
//  Created by wuyong on 15/12/11.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol ProtocolViewDelegate <NSObject>

@end

@interface ProtocolView : AppView

@property (retain, nonatomic) id<ProtocolViewDelegate> delegate;

- (void) stopWeb;

@end
