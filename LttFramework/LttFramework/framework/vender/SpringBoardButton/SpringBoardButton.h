//
//  SpringBoardButton.h
//  LttMember
//
//  Created by wuyong on 15/10/14.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpringBoardButton;

@protocol SpringBoardButtonDelegate <NSObject>

@required
- (NSArray *) dataSourceForBoardItems;

@optional
- (void) actionBoardItemClicked: (SpringBoardButton *)item;
- (BOOL) shouldBoardItemDeleted: (SpringBoardButton *)item;
- (void) actionBoardItemDeleted: (SpringBoardButton *)item;
- (void) actionBoardItemMoved: (SpringBoardButton *)item toIndex: (NSInteger)index;
- (void) actionBoardItemsStartEditing;
- (void) actionBoardItemsEndEditing;

@end

@interface SpringBoardButton : UIButton

@property (retain, nonatomic) id<SpringBoardButtonDelegate> delegate;

@property (assign, nonatomic) BOOL isEditing;

@property (assign, nonatomic) BOOL isEditable;

@end

@interface UIView (SpringBoardButton)

//设置容器代理，取消编辑等
- (void) setSpringBoardDelegate:(id<SpringBoardButtonDelegate>)delegate;

@end
