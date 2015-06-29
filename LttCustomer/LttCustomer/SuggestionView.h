//
//  ProfileNicknameView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/18.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol SuggestionViewDelegate <NSObject>

@required
- (void)actionSave:(NSString *)content;

@end

@interface SuggestionView : AppView

@property (nonatomic, retain) id<SuggestionViewDelegate> delegate;

@end
