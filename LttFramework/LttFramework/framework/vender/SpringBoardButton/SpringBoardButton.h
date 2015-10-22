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
- (NSArray *) dataSourceForBoardItems: (UIView *)boardView;

@optional
- (CGRect) deleteFrameForBoardItem: (SpringBoardButton *)item;
- (UIImage *) deleteImageForBoardItem: (SpringBoardButton *)item;
- (void) actionBoardItemClicked: (SpringBoardButton *)item;
- (BOOL) shouldBoardItemDeleted: (SpringBoardButton *)item;
- (void) actionBoardItemDeleted: (SpringBoardButton *)item;
- (void) actionBoardItemMoved: (SpringBoardButton *)item toIndex: (NSInteger)index;
- (void) actionBoardItemsStartEditing: (UIView *)boardView;
- (void) actionBoardItemsEndEditing: (UIView *)boardView;

@end

@interface SpringBoardButton : UIButton

@property (retain, nonatomic) id<SpringBoardButtonDelegate> delegate;

//容器视图，必须设置
@property (retain, nonatomic) UIView *boardView;

@property (assign, nonatomic) BOOL isEditing;

@property (assign, nonatomic) BOOL isEditable;

@end

@interface UIView (SpringBoardButton)

//设置容器代理，取消编辑等
- (void) setSpringBoardDelegate:(id<SpringBoardButtonDelegate>)delegate;

//获取或设置编辑模式
@property (assign, nonatomic) BOOL isSpringBoardEditing;

@end
