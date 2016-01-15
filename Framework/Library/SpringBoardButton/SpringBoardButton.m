//
//  SpringBoardButton.m
//  LttMember
//
//  Created by wuyong on 15/10/14.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "SpringBoardButton.h"
#import <objc/runtime.h>

@interface SpringBoardButton ()

@end

@implementation SpringBoardButton
{
    UIButton *deleteButton;
    BOOL _isEditing;
    
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认可编辑
        self.isEditable = YES;
        
        //绑定事件
        [self addTarget:self action:@selector(actionItemClicked) forControlEvents:UIControlEventTouchUpInside];
        
        //添加长按手势
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionLongPressed:)];
        [self addGestureRecognizer:longGesture];
    }
    return self;
}

- (void) setIsEditing:(BOOL)isEditing
{
    if (!self.isEditable) return;
    
    if (isEditing) {
        if (_isEditing) return;
        _isEditing = YES;
        
        CGFloat rotation = 0.03;
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
        shake.duration = 0.13;
        shake.autoreverses = YES;
        shake.repeatCount  = MAXFLOAT;
        shake.removedOnCompletion = NO;
        shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
        shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
        [self.layer addAnimation:shake forKey:@"shakeAnimation"];
        
        //添加删除按钮
        if (!deleteButton) {
            //获取删除按钮设置
            CGRect deleteFrame = CGRectMake(-10, -10, 20, 20);
            if ([self.delegate respondsToSelector:@selector(deleteFrameForBoardItem:)]) {
                deleteFrame = [self.delegate deleteFrameForBoardItem:self];
            }
            UIImage *deleteImage = nil;
            if ([self.delegate respondsToSelector:@selector(deleteImageForBoardItem:)]) {
                deleteImage = [self.delegate deleteImageForBoardItem:self];
            } else {
                deleteImage = [UIImage imageNamed:@"deleteItem"];
            }
            
            deleteButton = [[UIButton alloc] initWithFrame:deleteFrame];
            [deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
            [deleteButton setBackgroundImage:deleteImage forState:UIControlStateHighlighted];
            [deleteButton addTarget:self action:@selector(actionItemDeleted) forControlEvents:UIControlEventTouchUpInside];
            deleteButton.hidden = YES;
            [self addSubview:deleteButton];
        }
        
        deleteButton.hidden = NO;
    } else {
        if (!_isEditing) return;
        _isEditing = NO;
        
        [self.layer removeAnimationForKey:@"shakeAnimation"];
        
        deleteButton.hidden = YES;
    }
}

- (BOOL) isEditing
{
    return _isEditing;
}

//效果优化
- (void) removeFromSuperview
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        [self setFrame:CGRectMake(self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2, 0, 0)];
        [deleteButton setFrame:CGRectMake(0, 0, 0, 0)];
    }completion:^(BOOL finished) {
        deleteButton = nil;
        [super removeFromSuperview];
    }];
}

#pragma mark - Action
- (void) actionLongPressed: (UILongPressGestureRecognizer *)sender
{
    if (!self.isEditable) return;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //进入编辑模式
        if (!self.boardView.isSpringBoardEditing) {
            self.boardView.isSpringBoardEditing = YES;
        }
        
        startPoint = [sender locationInView:sender.view];
        originPoint = self.center;
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.alpha = 0.7;
        }];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        self.center = CGPointMake(self.center.x+deltaX,self.center.y+deltaY);
        NSInteger index = [self indexOfPoint:self.center];
        if (index<0) {
            contain = NO;
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                CGPoint temp = CGPointZero;
                UIButton *button = [[self.delegate dataSourceForBoardItems:self.boardView] objectAtIndex:index];
                temp = button.center;
                button.center = originPoint;
                self.center = temp;
                originPoint = self.center;
                contain = YES;
                //移动数据
                [self actionItemMoved:index];
            }];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1.0;
            if (!contain) {
                self.center = originPoint;
            }
        }];
    }
}

- (NSInteger)indexOfPoint:(CGPoint)point
{
    NSArray *items = [self.delegate dataSourceForBoardItems:self.boardView];
    for (NSInteger i = 0;i<items.count;i++) {
        SpringBoardButton *button = items[i];
        if (button != self) {
            if (CGRectContainsPoint(button.frame, point)) {
                return button.isEditable ? i : -1;
            }
        }
    }
    return -1;
}

- (void) actionItemClicked
{
    //编辑模式不可用
    if (self.isEditing) return;
    
    if ([self.delegate respondsToSelector:@selector(actionBoardItemClicked:)]) {
        [self.delegate actionBoardItemClicked:self];
    }
}

- (void) actionItemMoved: (NSInteger) toIndex
{
    if ([self.delegate respondsToSelector:@selector(actionBoardItemMoved:toIndex:)]) {
        [self.delegate actionBoardItemMoved:self toIndex:toIndex];
    }
}

- (BOOL) shouldItemDeleted
{
    if ([self.delegate respondsToSelector:@selector(shouldBoardItemDeleted:)]) {
        return [self.delegate shouldBoardItemDeleted:self];
    } else {
        return YES;
    }
}

- (void) actionItemDeleted
{
    //是否允许删除
    if (![self shouldItemDeleted]) return;
    
    //移除自己
    NSArray *items = [self.delegate dataSourceForBoardItems:self.boardView];
    NSInteger index = [items indexOfObject:self];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect lastFrame = self.frame;
        CGRect curFrame;
        for (NSInteger i = index; i < [items count]; i++) {
            UIButton *temp = [items objectAtIndex:i];
            curFrame = temp.frame;
            temp.frame = lastFrame;
            lastFrame = curFrame;
        }
    }];
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(actionBoardItemDeleted:)]) {
        [self.delegate actionBoardItemDeleted:self];
    }
}

@end

@implementation UIView (SpringBoardButton)

static const char SpringBoardDelegateKey = '\0';
- (void) setSpringBoardDelegate:(id<SpringBoardButtonDelegate>)delegate
{
    [self willChangeValueForKey:@"springBoardDelegate"];
    objc_setAssociatedObject(self, &SpringBoardDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"springBoardDelegate"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(springBoardHandler)];
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
}

- (void) springBoardHandler
{
    //退出编辑模式
    if (self.isSpringBoardEditing) {
        self.isSpringBoardEditing = NO;
    }
}

- (BOOL) isSpringBoardEditing
{
    id<SpringBoardButtonDelegate> delegate = objc_getAssociatedObject(self, &SpringBoardDelegateKey);
    NSArray *items = [delegate dataSourceForBoardItems:self];
    
    //检查是否有编辑模式的按钮
    BOOL isEditing = NO;
    for (SpringBoardButton *item in items) {
        if (!item.isEditing) continue;
        
        isEditing = YES;
        break;
    }
    return isEditing;
}

- (void) setIsSpringBoardEditing:(BOOL)isSpringBoardEditing
{
    //获取当前模式且未修改
    BOOL isEditing = self.isSpringBoardEditing;
    if (isSpringBoardEditing == isEditing) return;
    
    id<SpringBoardButtonDelegate> delegate = objc_getAssociatedObject(self, &SpringBoardDelegateKey);
    NSArray *items = [delegate dataSourceForBoardItems:self];
    
    //设置编辑模式
    BOOL isEditable = NO;
    for (SpringBoardButton *item in items) {
        if (!item.isEditable) continue;
        
        item.isEditing = isSpringBoardEditing;
        isEditable = YES;
    }
    if (!isEditable) return;
    
    //开始编辑
    if (isSpringBoardEditing) {
        if ([delegate respondsToSelector:@selector(actionBoardItemsStartEditing:)]) {
            [delegate actionBoardItemsStartEditing:self];
        }
    //结束编辑
    } else {
        if ([delegate respondsToSelector:@selector(actionBoardItemsEndEditing:)]) {
            [delegate actionBoardItemsEndEditing:self];
        }
    }
    
}

@end
