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
- (NSMutableArray *) itemsForItem: (SpringBoardButton *)item;

@optional
- (void) actionItemClicked: (SpringBoardButton *)item;
- (void) actionItemDeleted: (SpringBoardButton *)item;
- (void) actionItemMoved: (SpringBoardButton *)item toIndex: (NSInteger)index;
- (void) actionItemsStartEditing;
- (void) actionItemsEndEditing;

@end

@interface SpringBoardButton : UIButton

@property (retain, nonatomic) id<SpringBoardButtonDelegate> delegate;

@property (assign, nonatomic) BOOL isEditing;

@property (assign, nonatomic) BOOL isEditable;

//设置容器视图，取消编辑，多个只需设置一次即可
- (void) setContainerView:(UIView *)containerView;

@end
