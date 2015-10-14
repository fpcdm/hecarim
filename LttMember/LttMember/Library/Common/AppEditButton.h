//
//  AppEditButton.h
//  LttMember
//
//  Created by wuyong on 15/10/14.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppEditButton;

@protocol AppEditButtonDelegate <NSObject>

- (void) actionItemClicked: (AppEditButton *)item;
- (void) actionDeleteItem: (AppEditButton *)item;
- (NSMutableArray *) itemsForItem: (AppEditButton *)item;

@end

@interface AppEditButton : UIButton

@property (retain, nonatomic) id<AppEditButtonDelegate> delegate;

@property (assign, nonatomic) BOOL isEditing;

@property (assign, nonatomic) BOOL isEditable;

@end
