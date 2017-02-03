//
//  CustomGrid.m
//  MenuButton
//
//  Created by xiangronghua on 2017/2/3.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

#import "CustomGrid.h"

@implementation CustomGrid

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                  normalImage:(UIImage *)normalImage
             highlightedImage:(UIImage *)highlightedImage
                       gridId:(NSInteger)gridId
                      atIndex:(NSInteger)index
                  isAddDelete:(BOOL)isAddDelete
                   deleteIcon:(UIImage *)deleteIcon
                withIconImage:(NSString *)imageString {
    
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat pointX = (index % PerRowGridCount) * (GridWidth + PaddingX) + PaddingX;
        CGFloat pointY = (index / PerRowGridCount) * (GridHeight + PaddingY) + PaddingY;
        self.frame = CGRectMake(pointX, pointY, GridWidth+1, GridHeight+1);
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addTarget:self action:@selector(gridClick:) forControlEvents:UIControlEventTouchUpInside];
        [self initImageViewUI:imageString];
        [self initTitleLabel:title];
        [self setGridId:gridId];
        [self setGridIndex:index];
        [self setGridCenterPoint:self.center];
        [self buttonIsAddOrDelete:isAddDelete image:deleteIcon tag:gridId];
    }
    return self;
}

- (void)initImageViewUI:(NSString *)imageString {
    UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-18, 34, 36, 36)];
    imageIcon.image = [UIImage imageNamed:imageString];
    imageIcon.tag = self.gridId;
    [self addSubview:imageIcon];
}

- (void)initTitleLabel:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-42, 75, 84, 20)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = UIColorFromRGB(0x3c454c);
    [self addSubview:titleLabel];
}

//判断是否要添加删除图标
- (void)buttonIsAddOrDelete:(BOOL)isAddDelete image:(UIImage *)deleteIcon tag:(NSInteger)gridId {
    if (isAddDelete) {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(self.frame.size.width - 30, 10, 20, 20);
        [deleteButton setBackgroundColor:[UIColor clearColor]];
        [deleteButton setBackgroundImage:deleteIcon forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteGrid:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setHidden:YES];
        
        [deleteButton setTag:gridId];
        [self addSubview:deleteButton];
        
        //添加长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gridLongPress:)];
        [self addGestureRecognizer:longPressGesture];
        longPressGesture = nil;
        
    }
}

//响应格子点击事件
- (void)gridClick:(CustomGrid *)clickItem {
    if ([self.delegate respondsToSelector:@selector(gridItemDidClicked:)]) {
        [self.delegate gridItemDidClicked:clickItem];
    }
}

//响应格子删除事件
- (void)deleteGrid:(UIButton *)deleteButton {
    if ([self.delegate respondsToSelector:@selector(gridItemDidDeleteClicked:)]) {
        [self.delegate gridItemDidDeleteClicked:deleteButton];
    }
}

//响应格子的长安手势事件
- (void)gridLongPress:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if ([self.delegate respondsToSelector:@selector(pressGestureStateBegan:withGridItem:)]) {
                [self.delegate pressGestureStateBegan:longPressGesture withGridItem:self];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            //应用移动后的新坐标
            CGPoint newPoint = [longPressGesture locationInView:longPressGesture.view];
            if ([self.delegate respondsToSelector:@selector(pressGestureStateChangedWithPoint:gridItem:)]) {
                [self.delegate pressGestureStateChangedWithPoint:newPoint gridItem:self];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if ([self.delegate respondsToSelector:@selector(pressGestureStateEnded:)]) {
                [self.delegate pressGestureStateEnded:self];
            }
            break;
        }
        default:
            break;
    }
}

//根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray {
    
    for (NSInteger i = 0; i < gridListArray.count; i++) {
        UIButton *appButton = [gridListArray objectAtIndex:i];
        if (appButton != btn) {
            //判断一个CGPoint 是否包含再另一个UIView的CGRect里面,常用与测试给定的对象之间是否又重叠
            if (CGRectContainsPoint(appButton.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}

@end
