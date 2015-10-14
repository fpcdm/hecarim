//
//  AppEditButton.m
//  LttMember
//
//  Created by wuyong on 15/10/14.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppEditButton.h"

@implementation AppEditButton
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
        [self addTarget:self action:@selector(actionItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加删除按钮
        deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, -10, 20, 20)];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteItem"] forState:UIControlStateNormal];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteItem"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(actionDeleteItem:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.hidden = YES;
        [self addSubview:deleteButton];
        
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
        [self enableEditing];
    } else {
        [self disableEditing];
    }
}

- (BOOL) isEditing
{
    return _isEditing;
}

- (void) enableEditing
{
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
    
    deleteButton.hidden = NO;
}

- (void) disableEditing
{
    if (!_isEditing) return;
    _isEditing = NO;
    
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    
    deleteButton.hidden = YES;
}

//效果优化
- (void) removeFromSuperview
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        [self setFrame:CGRectMake(self.frame.origin.x+50, self.frame.origin.y+50, 0, 0)];
        [deleteButton setFrame:CGRectMake(0, 0, 0, 0)];
    }completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

#pragma mark - Action
- (void) actionLongPressed: (UILongPressGestureRecognizer *)sender
{
    if (!self.isEditable) return;
    
    NSArray *items = [self.delegate itemsForItem:self];
    if (sender.state == UIGestureRecognizerStateBegan) {
        //进入编辑模式
        if (!_isEditing) {
            for (AppEditButton *item in items) {
                item.isEditing = YES;
            }
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
                UIButton *button = items[index];
                temp = button.center;
                button.center = originPoint;
                self.center = temp;
                originPoint = self.center;
                contain = YES;
            }];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        //todo: 解析移动结果
        
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
    NSArray *items = [self.delegate itemsForItem:self];
    for (NSInteger i = 0;i<items.count;i++) {
        AppEditButton *button = items[i];
        if (button != self) {
            if (CGRectContainsPoint(button.frame, point)) {
                return button.isEditable ? i : -1;
            }
        }
    }
    return -1;
}

- (void) actionItemClicked: (UIButton *)sender
{
    //编辑模式不可用
    if (_isEditing) return;
    
    [self.delegate actionItemClicked:self];
}

- (void) actionDeleteItem: (UIButton *)sender
{
    //移除自己
    NSArray *items = [self.delegate itemsForItem:self];
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
    
    [self.delegate actionDeleteItem:self];
}

@end
