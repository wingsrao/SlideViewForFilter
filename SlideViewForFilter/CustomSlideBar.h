//
//  CustomSlideBar.h
//  Vasse
//
//  Created by 饶首建 on 16/5/18.
//  Copyright © 2016年 voossi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSidebarWidth [UIScreen mainScreen].bounds.size.width*0.8
#define kSBWidth [UIScreen mainScreen].bounds.size.width
#define kSBHeight [UIScreen mainScreen].bounds.size.height

@interface CustomSlideBar : UIViewController

@property (nonatomic, retain) UIView* contentView; //侧滑容器
@property (nonatomic, assign) BOOL isSidebarShown;

/**
 * 设置侧栏的背景色
 */
- (void)setBgColor:(UIColor*)color;

/**
 * 当有pan事件时调用，传入UIPanGestureRecognizer
 */
- (void)panDetected:(UIPanGestureRecognizer *)recoginzer;

/**
 * 显示/隐藏Sidebar
 */
- (void)showHideSidebar;

/**
 * 已经完成显示，需要时可以在子类中用
 */
- (void)sidebarDidShown;

/**
 * 触发了右滑事件，需要时可以在子类中用
 */
- (void)slideToRight;

@end
