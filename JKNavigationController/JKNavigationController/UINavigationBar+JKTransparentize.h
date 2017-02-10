//
//  UINavigationBar+JKTransparentize.h
//  JKNavigationController
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationBar (JKTransparentize)


/**
 设置NavigationBar的背景颜色，建议只设置一次，在JKNavigationController的内部封装中，Push过程中会执行\
 toViewController.navigationController.navigationBar.jk_barBackgroundColor = fromViewController.navigationController.navigationBar.jk_barBackgroundColor\
 也就是toViewController.navigationBar的背景会沿用fromViewController的效果，具有一定的全局效果。\
 如果只改变当前控制器navigationBar的背景颜色，则调用jk_setNavigationBarBackgroundColor:color
 

 */
@property (nonatomic, strong) UIColor * jk_barBackgroundColor;



/**
 自定义View，充当navigationBar的背景View
 */
@property (nonatomic, strong, readonly) UIView * jk_backgroundView;



/**
 设置NavigationBar的tintColor，并且重绘JKBackIndicatorButton的图片

 @param tintColor tintColor
 */
- (void)jk_setTintColor:(UIColor *)tintColor;


/**
 设置自定义的背景颜色

 @param backgroundColor 背景颜色
 */
- (void)jk_setNavigationBarBackgroundColor:(UIColor *)backgroundColor;


/**
 设置NavigationBar的垂直方向偏移，并调用jk_setNavigationBarSubViewsAlpha：

 @param offsetY offsetY
 */
- (void)jk_setNavigationBarVerticalOffsetY:(CGFloat)offsetY;


/**
 设置主要子控件的透明度（按钮、TitleView啥的）

 */
- (void)jk_setNavigationBarSubViewsAlpha:(CGFloat)alpha;


/**
 重置还原NavigationBar
 */
- (void)jk_resetNavigationBar;
@end
