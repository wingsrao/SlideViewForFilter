//
//  CustomSlideBar.m
//  Vasse
//
//  Created by 饶首建 on 16/5/18.
//  Copyright © 2016年 voossi. All rights reserved.
//

#import "CustomSlideBar.h"
#import <Accelerate/Accelerate.h>

#define duration 0.2

@interface CustomSlideBar() <UIGestureRecognizerDelegate>
{
    CGPoint startTouchPoint; // 手指按下时的坐标
    CGFloat startContentOriginX; // 移动前的窗口位置
    BOOL _isMoving;
    UIColor *_bgColor;
}

@property (nonatomic, retain) UIView* shadowView;

@end


@implementation CustomSlideBar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.userInteractionEnabled = YES;
    [self.view addSubview:self.shadowView];
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.alpha = 0;
    
    UITapGestureRecognizer *tapShadow = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSlideBar)];
    [self.shadowView addGestureRecognizer:tapShadow];
    
    _bgColor = [UIColor whiteColor];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    
    //列表
    CGRect rect = CGRectMake(kSBWidth, 0, kSidebarWidth, self.view.bounds.size.height);
    self.contentView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:self.contentView];
    
    self.view.hidden = YES;
}

- (void)hideSlideBar{
    [self showHideSidebar];
}


#pragma mark - 显示/隐藏

- (BOOL)isSidebarShown{
    return self.contentView.frame.origin.x < kSidebarWidth ? YES :NO;
}

- (void)showHideSidebar{
    if (self.contentView.frame.origin.x == kSBWidth) {
        startContentOriginX = self.contentView.frame.origin.x;
    }
    [self autoShowHideSidebar];
}

#pragma mark 子类中可用的
- (void)slideToRight
{
//    NSLog(@"触发了右滑事件，需要时可以在子类中用");
}

- (void)sidebarDidShown
{
//    NSLog(@"已经完成显示，需要时可以在子类中用");
}

#pragma mark Private
- (void)autoShowHideSidebar
{
    if (!self.isSidebarShown){
//        NSLog(@"自动弹出");
        self.view.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:kSBWidth - kSidebarWidth];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            [self sidebarDidShown];
        }];
    }else{
//        NSLog(@"自动缩回");
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:kSBWidth];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.view.hidden = YES;
            [self slideToRight];
        }];
    }
}

#pragma mark - 手势响应
- (void)tapDetected:(UITapGestureRecognizer*)recognizer
{
    [self autoShowHideSidebar];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    if (point.x < kSBWidth) {
        return NO;
    }
    return  YES;
}

- (void)panDetected:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint touchPoint = [recoginzer locationInView:self.view];
    CGFloat offsetX =  touchPoint.x - startTouchPoint.x;
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _isMoving = YES;
        startTouchPoint = touchPoint;
        self.view.hidden = NO;
        // 记录按下时的x位置
        startContentOriginX = self.contentView.frame.origin.x;
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        if (offsetX > 40 || ((int)startContentOriginX==0 && offsetX<0 && offsetX>-20)){
//            NSLog(@"隐藏");
            [UIView animateWithDuration:duration animations:^{
                [self setSidebarOriginX:kSBWidth];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.view.hidden = YES;
                [self slideToRight];
            }];
        }else{
//            NSLog(@"显示");
            self.view.hidden = NO;
            [UIView animateWithDuration:duration animations:^{
                [self setSidebarOriginX:kSBWidth - kSidebarWidth];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                [self sidebarDidShown];
            }];
        }
        return;
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:kSBWidth];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.view.hidden = YES;
        }];
        return;
    }
    
    if (_isMoving) {
        [self setSidebarOffset:offsetX];
    }
    
}

#pragma mark - 侧栏出来
/*
 * 设置侧栏位置
 * 完全不显示时为x=kWidth，显示到最右时x=kWidth-kSidebarWidth
 */
- (void)setSidebarOriginX:(CGFloat)x
{
    CGRect rect = self.contentView.frame;
    rect.origin.x = x;
    [self.contentView setFrame:rect];
    
    [self setShadowViewAlpha];
}

/*
 * 设置侧栏相对于开始点击时的偏移
 * offset>0向左，offset<0向右
 */
- (void)setSidebarOffset:(CGFloat)offset
{
    CGRect rect = self.contentView.frame;
    if (offset < 0) { // 左滑
        // 如果不在最左
        if (rect.origin.x<0) {
            rect.origin.x = startContentOriginX + offset; // 直接向左偏移这么多
            if (rect.origin.x > 0) {
                rect.origin.x = 0;
            }
        }
    } else { // 右滑
        // 如果不在最右
        if (rect.origin.x > kSidebarWidth) {
            rect.origin.x = startContentOriginX + offset;
            if (rect.origin.x < kSidebarWidth) {
                rect.origin.x = kSidebarWidth;
            }
        }
    }
    [self.contentView setFrame:rect];
    [self setShadowViewAlpha];
    
}

- (void)setShadowViewAlpha
{
    self.shadowView.alpha = 0.4;
    self.contentView.backgroundColor = _bgColor;
}

- (void)setBgColor:(UIColor *)color{
    _bgColor = color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
